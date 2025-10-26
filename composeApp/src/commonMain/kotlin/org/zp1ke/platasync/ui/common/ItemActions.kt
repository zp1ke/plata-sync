package org.zp1ke.platasync.ui.common

import org.zp1ke.platasync.domain.BaseModel

interface ItemActions<T : BaseModel> {
    fun onView(item: T)
    fun onEdit(item: T)
    fun onDelete(item: T)
}