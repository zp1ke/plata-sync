package org.zp1ke.platasync.ui.common

import org.zp1ke.platasync.domain.DomainModel

interface ItemActions<T : DomainModel> {
    fun onView(item: T)
    fun onEdit(item: T)
    fun onDelete(item: T)
}