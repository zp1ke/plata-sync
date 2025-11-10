package org.zp1ke.platasync.data.model

import org.zp1ke.platasync.domain.DomainModel

data class ScreenState<T : DomainModel>(
    val data: List<T>,
    val isLoading: Boolean,
)
