package com.example.track_birr.data.local

import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity(tableName = "examples")
data class ExampleEntity(
    @PrimaryKey(autoGenerate = true)
    val id: Int = 0,
    val name: String
)
