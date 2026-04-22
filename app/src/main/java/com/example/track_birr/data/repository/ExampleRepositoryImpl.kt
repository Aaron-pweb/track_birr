package com.example.track_birr.data.repository

import com.example.track_birr.data.local.ExampleDao
import com.example.track_birr.data.local.ExampleEntity
import com.example.track_birr.domain.repository.ExampleRepository
import kotlinx.coroutines.flow.Flow
import javax.inject.Inject

class ExampleRepositoryImpl @Inject constructor(
    private val exampleDao: ExampleDao
) : ExampleRepository {
    override fun getAllExamples(): Flow<List<ExampleEntity>> = exampleDao.getAllExamples()

    override suspend fun insertExample(example: ExampleEntity) {
        exampleDao.insertExample(example)
    }
}
