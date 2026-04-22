package com.example.track_birr.ui.viewmodels

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.example.track_birr.data.local.ExampleEntity
import com.example.track_birr.domain.repository.ExampleRepository
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class HomeViewModel @Inject constructor(
    private val repository: ExampleRepository
) : ViewModel() {

    private val _uiState = MutableStateFlow<List<ExampleEntity>>(emptyList())
    val uiState: StateFlow<List<ExampleEntity>> = _uiState

    init {
        viewModelScope.launch {
            repository.getAllExamples().collect {
                _uiState.value = it
            }
        }
    }

    fun addExample(name: String) {
        viewModelScope.launch {
            repository.insertExample(ExampleEntity(name = name))
        }
    }
}
