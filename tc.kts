// BuildAll
import java.io.File
import org.slf4j.LoggerFactory
import org.apache.commons.exec.CommandLine
import org.apache.commons.exec.DefaultExecutor
import org.apache.commons.exec.ExecuteException
import org.apache.commons.exec.PumpStreamHandler
import java.io.IOException
import kotlin.system.exitProcess

val log = LoggerFactory.getLogger("BA")

/*
    common
*/
fun check_call(inCmd: String, inWorkdir: String? = null): Boolean {
    val ret: Boolean
    try {
        val cmd = CommandLine.parse(inCmd)
        log.run {
            info("CMD: $cmd, workDir: $inWorkdir")
        }
        val exec = DefaultExecutor()
        inWorkdir?.let { exec.workingDirectory = File(it) }
        exec.execute(cmd)
        ret = true
    } catch (e: java.lang.IllegalArgumentException) {
        log.error("$e: can not parse command: [$inCmd]")
        throw e
    } catch (e: ExecuteException) {
        log.error("$e: can not exec command")
        throw e
    } catch (e: IOException) {
        log.error("$e: can not exec command")
        throw e
    }
    return ret
}

/*
    tasks
*/
fun copyJson(src: String, tgt: String) {
    log.info("Copying $src --> $tgt")
    File(src).copyTo(File(tgt), overwrite = true)
}

open class BuildAllConfig(
    open var taskName: String = "NA",
    open var product: String = "dolphin",
    open var android: String = "q",
    open var aosp: String = "aosp",
    open var suffix: String = ""
) {
    open fun fullDir(): String {
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

class BuildAllConfig2(
    override var taskName: String = "NA",
    override var product: String = "dolphin",
    override var android: String = "q",
    override var aosp: String = "aosp",
    override var suffix: String = ""): BuildAllConfig(taskName, product, android, aosp, suffix) {
    override fun fullDir(): String {
        return File("/Codebase_s/yyu/${product}_${android}_${aosp}").path
    }
}

val dolphin_Q_AOSP = BuildAllConfig("dolphin_Q_AOSP", "dolphin", "Q", "AOSP")
val dolphin_Q_GMS_AB = BuildAllConfig("dolphin_Q_GMS_AB", "dolphin", "Q", "GMS_AB", "")
val dolphin_Q_AOSP_AB = BuildAllConfig("dolphin_Q_AOSP_AB", "dolphin", "Q", "AOSP_AB", "")
val sequoia_Q_GMS_29_AB = BuildAllConfig("sequoia_Q_GMS_29_AB", "sequoia", "Q", "GMS_29_AB", "")
val sequoia_Q_14 = BuildAllConfig("sequoia_Q_GMS_14", "sequoia", "Q", "14")
val sequoia_Q_AOSP_AB = BuildAllConfig("sequoia_Q_AOSP_AB", "sequoia", "Q", "AOSP_AB", "")
val dolphin_R_AOSP_30_AB = BuildAllConfig("dolphin_R_AOSP_30_AB", "dolphin", "R", "AOSP_30_AB", "")
val dolphin_R_AOSP_29_A = BuildAllConfig("dolphin_R_AOSP_29_A", "dolphin", "R", "AOSP_29_A", "")
val dolphin_R_AOSP_29_AB = BuildAllConfig("dolphin_R_AOSP_29_AB", "dolphin", "R", "AOSP_29_AB", "")
val dolphin_R_GMS_30_AB = BuildAllConfig("dolphin_R_GMS_30_AB", "dolphin", "R", "GMS_30_AB", "")
val dolphin_R_GMS_30_AB17 = BuildAllConfig("dolphin_R_GMS_30_AB17", "dolphin", "R", "GMS_30_AB17", "")
val dolphin_R_GMS_29_AB = BuildAllConfig("dolphin_R_GMS_29_AB", "dolphin", "R", "GMS_29_AB", "")
val dolphin_S_GMS_31_AB = BuildAllConfig("dolphin_S_GMS_31_AB", "dolphin", "S", "GMS_31_AB", "")
val dolphin_S_GMS_30_AB = BuildAllConfig("dolphin_S_GMS_30_AB", "dolphin", "S", "GMS_30_AB", "")
val dolphin_T_GMS_33    = BuildAllConfig("dolphin_T_GMS_33", "dolphin", "T", "GMS_33", "")
val elektra_R_GMS = BuildAllConfig("elektra_R_GMS", "elektra", "R", "GMS", "29_A")
val sequoia_R_AOSP_29_A = BuildAllConfig("sequoia_R_AOSP_29_A", "sequoia", "R", "AOSP_29_A", "")
val sequoia_R_AOSP_29_AB = BuildAllConfig("sequoia_R_AOSP_29_AB", "sequoia", "R", "AOSP_29_AB", "")
val sequoia_R_GMS_29_A = BuildAllConfig("sequoia_R_GMS_29_A", "sequoia", "R", "GMS_29_A", "")
val sequoia_R_GMS_29_AB = BuildAllConfig("sequoia_R_GMS_29_AB", "sequoia", "R", "GMS_29_AB", "")
val platypus_R_AOSP_30_AB = BuildAllConfig("platypus_R_AOSP_30_AB", "platypus", "R", "AOSP_30_AB", "")
val platypus_R_AOSP_30_AB_pure = BuildAllConfig("platypus_R_AOSP_30_AB_pure", "platypus", "R", "AOSP_30_AB_pure", "")
val platypus_R_GMS_30_AB = BuildAllConfig("platypus_R_GMS_30_AB", "platypus", "R", "GMS_30_AB", "")
val platypus_S_GMS_30_AB = BuildAllConfig("platypus_S_GMS_30_AB", "platypus", "S", "GMS_30_AB", "")
val platypus_S_AOSP_31 = BuildAllConfig("platypus_S_AOSP_31", "platypus", "S", "AOSP_31_AB", "")
val platypus_S_GMS_31_AB = BuildAllConfig("platypus_S_GMS_31_AB", "platypus", "S", "GMS_31_AB", "")
val lk02_S_GMS = BuildAllConfig("lk02_S_GMS", "lk02", "S", "GMS", "31_AB")
val orca_S_GMS_31_AB = BuildAllConfig("orca_S_GMS_31_AB", "orca", "S", "GMS_31_AB", "")
// cust proj
val dennis_Q_AOSP_AB = BuildAllConfig("dennis_Q_AOSP_AB", "dennis", "Q", "AOSP_AB", "")
val igarnet_Q_GMS_AB = BuildAllConfig("igarnet_Q_GMS_AB", "igarnet", "Q", "GMS_AB", "")
val elektra_Q_GMS = BuildAllConfig("elektra_Q_GMS", "elektra", "Q", "GMS", "29_A")
val amber_Q_GMS = BuildAllConfig("amber_Q_GMS", "amber", "Q", "GMS")
// Google AOSP source
val platypus_master = BuildAllConfig("platypus_master", "platypus", "master")
val cf_master = BuildAllConfig("cf_master", "cf", "master")
val barbet_stable = BuildAllConfig("barbet_stable", "barbet", "stable")

val androidTasks = arrayOf(dolphin_Q_AOSP, dolphin_Q_GMS_AB, dolphin_Q_AOSP_AB,
        dennis_Q_AOSP_AB,
        igarnet_Q_GMS_AB,
        amber_Q_GMS,
        elektra_Q_GMS, elektra_R_GMS,
        sequoia_Q_GMS_29_AB, sequoia_Q_AOSP_AB, sequoia_Q_14,
        dolphin_R_AOSP_30_AB,
        dolphin_R_AOSP_29_A,
        dolphin_R_AOSP_29_AB,
        dolphin_R_GMS_30_AB,
        dolphin_R_GMS_30_AB17,
        dolphin_R_GMS_29_AB,
        dolphin_S_GMS_31_AB,
        dolphin_S_GMS_30_AB,
        dolphin_T_GMS_33,
        sequoia_R_AOSP_29_A, sequoia_R_AOSP_29_AB, sequoia_R_GMS_29_A, sequoia_R_GMS_29_AB,
        platypus_R_AOSP_30_AB_pure, platypus_R_AOSP_30_AB, platypus_R_GMS_30_AB,
        platypus_S_GMS_30_AB, platypus_S_AOSP_31, platypus_S_GMS_31_AB,
        lk02_S_GMS,
        orca_S_GMS_31_AB,
        platypus_master, cf_master, barbet_stable)

if (args.isEmpty()) {
    log.error("No args")
    exitProcess(1)
}

var bFound = false
val proj = args[0]
println("proj name is $proj")

var droid = "x"
when (proj) {
    "dolphin_110_GMS", "dolphin_S_GMS", "dolphin_S_AOSP_31", "bg5ct_s", "platypus_S_AOSP_31", "musen" -> {
        droid = "s"
    }
    "dolphin_T_AOSP_33", "platypus_T_GMS" -> {
        droid = "t"
    }
    "dolphin_U_AOSP_34", "dolphin_U_GMS_34" -> {
        droid = "u"
    }
    else -> {
    }
}

if (proj == "sdk_defconfig") {
    val prof = when (System.getenv("profile")) {
        "platypus_sl" -> Pair("platypus", "platypus_sl")
        "platypus_rl" -> Pair("platypus", "platypus_rl")
        "platypus_sl_64b" -> Pair("platypus", "platypus_sl_64b")
        "dolphin_sl_64b" -> Pair("dolphin", "dolphin_sl_64b")
        "dolphin_sl" -> Pair("dolphin", "dolphin_sl")
        "dolphin_rl" -> Pair("dolphin", "dolphin_rl")
        "dolphin_ql_non_ab" -> Pair("dolphin", "dolphin_ql_non_ab")
        else -> Pair("NULL", "NULL")
    }
    check_call("vendor/synaptics/build/build_androidtv -p vendor/synaptics/" + prof.first + "/configs/" + prof.second + " -m ../s -sprepare",
        System.getProperty("user.home") + "/city/dolphin_S_GMS/android_s")
    File(System.getProperty("user.home") + "/city/dolphin_S_GMS/s/configs/profile.zip").let {
        if (it.exists()) {
            log.info("clean previous profile zip: " + it.getAbsolutePath())
            it.delete()
        }
    }
    check_call("zip -r profile.zip product/" + prof.first,
        System.getProperty("user.home") + "/city/dolphin_S_GMS/s/configs")
} else {
    check_call("make android_init_$proj theCmd=$proj")
    check_call("make sdk_init_$proj theCmd=$proj")
    check_call("make android_${droid}_clean theCmd=$proj")
    check_call("make sdk_clean theCmd=$proj")
    check_call("make android_${droid}_sync theCmd=$proj")
    check_call("make sdk_sync theCmd=$proj")
    check_call("make android_post_sync_$proj theCmd=$proj")
    check_call("make sdk_post_sync_$proj theCmd=$proj")
    check_call("make android_build_$proj theCmd=$proj")
}
