package org.zp1ke.platasync

import org.koin.core.annotation.ComponentScan
import org.koin.core.annotation.Module

@Module
@ComponentScan
class AppModule

expect fun appModule(): org.koin.core.module.Module

