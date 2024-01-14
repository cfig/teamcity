buildscript {
    repositories {
        jcenter()
    }
    dependencies {
    }
}

plugins {
    id("org.jetbrains.kotlin.jvm") version "1.4.10"
    application
}

repositories {
    jcenter()
}

dependencies {
    implementation(platform("org.jetbrains.kotlin:kotlin-bom"))
    implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk8")
    implementation("org.jetbrains.kotlin:kotlin-reflect")
}

application {
    // Define the main class for the application.
    mainClassName = "cfig.blueprint.AppKt"
}

data class BuildAllConfig(
    var taskName: String = "NA",
    var product: String = "dolphin",
    var android: String = "q",
    var aosp: String = "aosp",
    var suffix: String = ""
) {
    fun fullDir(): String {
        return File(System.getProperty("user.home") + "/city/${product}_${android}_${aosp}").path
    }
    fun jsonPath(): String {
        var ret = "${product}_${android}_${aosp}"
        if (suffix.isNotBlank()) {
            ret = "${ret}_${suffix}"
        }
        return ret + ".json"
    }
}

val dolphin_Q_GMS = BuildAllConfig("dolphin_Q_GMS", "dolphin", "Q", "GMS")
val dolphin_Q_GMS_AB = BuildAllConfig("dolphin_Q_GMS_AB", "dolphin", "Q", "GMS", "AB")
val dolphin_Q_AOSP_AB = BuildAllConfig("dolphin_Q_AOSP_AB", "dolphin", "Q", "AOSP", "AB")
val sequoia_Q_GMS_AB = BuildAllConfig("sequoia_Q_GMS_AB", "sequoia", "Q", "GMS", "AB")
val sequoia_Q_AOSP_AB = BuildAllConfig("sequoia_Q_AOSP_AB", "sequoia", "Q", "AOSP", "AB")
val dolphin_R_AOSP_AB = BuildAllConfig("dolphin_R_AOSP_AB", "dolphin", "R", "AOSP", "AB")
val sequoia_R_AOSP = BuildAllConfig("sequoia_R_AOSP", "sequoia", "R", "AOSP")
// cust proj
val elektra_Q_GMS = BuildAllConfig("elektra_Q_GMS", "elektra", "Q", "GMS")

val androidTasks = arrayOf(dolphin_Q_GMS, dolphin_Q_GMS_AB, dolphin_Q_AOSP_AB,
        sequoia_Q_GMS_AB, sequoia_Q_AOSP_AB,
        dolphin_R_AOSP_AB,
        sequoia_R_AOSP,
        elektra_Q_GMS)

tasks.register("x") {
    println("to:" + dolphin_Q_GMS.fullDir())
    println(dolphin_Q_GMS_AB)
    println(dolphin_Q_GMS_AB.fullDir())
    println(dolphin_Q_GMS_AB.jsonPath())
}

androidTasks.forEach {
    tasks.register<Copy>(it.taskName + "_cfg") {
        group = "city"
        from(it.jsonPath())
        into(it.fullDir())
        rename(".*", "build.json")
        eachFile { logger.warn("Copying " + this.name) }
        if (inputs.sourceFiles.isEmpty()) {
            throw IllegalArgumentException("src file empty")
        }
    }

    tasks.register<Exec>(it.taskName) {
        group = "city"
        workingDir(it.fullDir())
        commandLine("ba")
        dependsOn(":" + it.taskName + "_cfg")
    }
}

// TEST Tasks
val XTS_ARGS = "--skip-device-info --skip-preconditions"

val CTS_DIR = System.getProperty("user.home") + "/work/xTs/CTS/android-cts"
val CTS = "tools/cts-tradefed"
val CTS_ARGS  = "run commandAndExit cts"

val VTS_DIR = System.getProperty("user.home") + "/work/xTs/VTS/android-vts"
val VTS = "tools/vts-tradefed"
val VTS_ARGS  = "run commandAndExit vts"

tasks.register<Exec>("cts") {
    group = "xTS"
    workingDir(CTS_DIR)
    val theCmd = System.getenv("theCmd")
    if (theCmd == null) {
        logger.warn("Running full CTS plan")
        commandLine(("./$CTS $CTS_ARGS").split("\\s".toRegex()))
    } else {
        commandLine(("./$CTS $CTS_ARGS $XTS_ARGS $theCmd").split("\\s".toRegex()))
    }
}
tasks.register<Exec>("cts-retry") {
    group = "xTS"
    workingDir(CTS_DIR)
    val theCmd = System.getenv("theCmd")
    if (theCmd == null) {
        logger.warn("Running full CTS plan")
        commandLine(("./$CTS $CTS_ARGS").split("\\s".toRegex()))
    } else {
        commandLine(("./$CTS run commandAndExit retry --retry $theCmd").split("\\s".toRegex()))
    }
}

tasks.register<Exec>("vts") {
    group = "xTS"
    workingDir(VTS_DIR)
    val theCmd = System.getenv("theCmd")
    if (theCmd == null) {
        logger.warn("Running full VTS plan")
        commandLine(("./$VTS $VTS_ARGS").split("\\s".toRegex()))
    } else {
        commandLine(("./$VTS $VTS_ARGS $XTS_ARGS $theCmd").split("\\s".toRegex()))
    }
}

tasks.register<Exec>("burn") {
    group = "xTS"
    //workingDir(VTS_DIR)
    val theCmd = System.getenv("theCmd")
    if (theCmd == null) {
        commandLine("false".split("\\s".toRegex()))
    } else {
        commandLine(("make -f burn.mk all theCmd=$theCmd").split("\\s".toRegex()))
    }
}
