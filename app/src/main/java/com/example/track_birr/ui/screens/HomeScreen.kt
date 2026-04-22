package com.example.track_birr.ui.screens

import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.Button
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import com.example.track_birr.ui.viewmodels.HomeViewModel

@Composable
fun HomeScreen(
    modifier: Modifier = Modifier,
    viewModel: HomeViewModel = hiltViewModel()
) {
    val examples by viewModel.uiState.collectAsState()

    Column(modifier = modifier.padding(16.dp)) {
        Button(onClick = { viewModel.addExample("New Item ${examples.size + 1}") }) {
            Text("Add Example")
        }

        LazyColumn {
            items(examples) { example ->
                Text(text = "Example: ${example.name}", modifier = Modifier.padding(8.dp))
            }
        }
    }
}
