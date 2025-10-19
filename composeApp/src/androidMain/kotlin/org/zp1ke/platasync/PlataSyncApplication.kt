package org.zp1ke.platasync

import android.app.Application
import org.koin.android.ext.koin.androidContext
import org.koin.core.context.startKoin
import org.koin.ksp.generated.module

class PlataSyncApplication : Application() {
    override fun onCreate() {
        super.onCreate()
        startKoin {
            androidContext(this@PlataSyncApplication)
            modules(AppModule().module)
        }
    }
}

