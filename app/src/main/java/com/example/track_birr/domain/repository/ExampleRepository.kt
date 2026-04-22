package com.example.track_birr.domain.repository

import com.example.track_birr.data.local.ExampleEntity
import kotlinx.coroutines.flow.Flow

interface ExampleRepository {
    fun getAllExamples(): Flow<List<ExampleEntity>>
    suspend fun insertExample(example: ExampleEntity)
}
