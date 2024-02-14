package com.solitics.integration.app.logger

import android.content.Context
import android.util.Log
import com.solitics.integration.app.domain.utils.log
import java.io.BufferedReader
import java.io.File
import java.io.FileReader
import java.io.FileWriter
import java.io.IOException
import java.util.Date

object FileLogger {

    private const val TAG = "FileLogger"
    private const val LOG_FILE_NAME = "app_log.txt"

    @JvmStatic
    fun log(context: Context, tag: String, message: String?) {
        log(tag = tag, message = message.toString())

        buildString {
            append(message)
            append(" -at- ")
            append(Date(System.currentTimeMillis()))
        }.also { writeToFile(context, it) }
    }

    fun readLogFile(context: Context): String {
        val logContents = StringBuilder()

        try {
            val logFile = File(context.getExternalFilesDir(null), LOG_FILE_NAME)
            val fileReader = FileReader(logFile)
            val bufferedReader = BufferedReader(fileReader)

            var line: String?
            while (bufferedReader.readLine().also { line = it } != null) {
                logContents.append(line).append("\n")
            }

            bufferedReader.close()
            fileReader.close()
        } catch (e: IOException) {
            Log.e(TAG, "Error reading log file: ${e.message}")
        }

        return logContents.toString()
    }

    private fun writeToFile(context: Context, message: String) {
        try {
            val logFile = File(context.getExternalFilesDir(null), LOG_FILE_NAME)
            val writer = FileWriter(logFile, true)
            writer.append(message).append("\n")
            writer.flush()
            writer.close()
        } catch (e: IOException) {
            Log.e(TAG, "Error writing to log file: ${e.message}")
        }
    }

    fun deleteFileContent(context: Context) {
        try {
            val logFile = File(context.getExternalFilesDir(null), LOG_FILE_NAME)
            val writer = FileWriter(logFile, false) // pass 'false' to truncate the file
            writer.close()
        } catch (e: IOException) {
            Log.e(TAG, "Error deleting file content: ${e.message}")
        }
    }
}
