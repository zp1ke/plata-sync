package org.zp1ke.platasync

interface Platform {
    val name: String
}

expect fun getPlatform(): Platform