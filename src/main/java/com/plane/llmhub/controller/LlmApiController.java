package com.plane.llmhub.controller;

import com.plane.llmhub.model.Category;
import com.plane.llmhub.model.LlmModel;
import com.plane.llmhub.model.ModelContent;
import com.plane.llmhub.service.LlmService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api")
@CrossOrigin(origins = "*")
public class LlmApiController {

    private final LlmService llmService;

    public LlmApiController(LlmService llmService) {
        this.llmService = llmService;
    }

    @GetMapping("/categories")
    public ResponseEntity<List<Category>> getCategories() {
        return ResponseEntity.ok(llmService.getAllCategories());
    }

    @GetMapping("/models")
    public ResponseEntity<List<LlmModel>> getModels(@RequestParam(required = false) String category) {
        if (category != null && !category.trim().isEmpty()) {
            return ResponseEntity.ok(llmService.getModelsByCategorySlug(category));
        }
        return ResponseEntity.ok(llmService.getAllModels());
    }

    @GetMapping("/models/{modelKey}")
    public ResponseEntity<LlmModel> getModelDetails(@PathVariable String modelKey) {
        LlmModel model = llmService.getModelDetailsByKey(modelKey);
        if (model == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(model);
    }

    @GetMapping("/models/{modelKey}/contents")
    public ResponseEntity<List<ModelContent>> getModelContents(@PathVariable String modelKey) {
        LlmModel model = llmService.getModelDetailsByKey(modelKey);
        if (model == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(llmService.getModelContents(model.getId()));
    }

    @GetMapping("/search")
    public ResponseEntity<List<LlmModel>> searchModels(@RequestParam(defaultValue = "") String q) {
        return ResponseEntity.ok(llmService.search(q));
    }

    @GetMapping("/stats")
    public ResponseEntity<Map<String, Object>> getStats() {
        return ResponseEntity.ok(llmService.getWorkspaceStats());
    }
}
