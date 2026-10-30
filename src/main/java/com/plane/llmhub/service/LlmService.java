package com.plane.llmhub.service;

import com.plane.llmhub.mapper.CategoryMapper;
import com.plane.llmhub.mapper.ContentMapper;
import com.plane.llmhub.mapper.MetricMapper;
import com.plane.llmhub.mapper.ModelMapper;
import com.plane.llmhub.model.Category;
import com.plane.llmhub.model.LlmModel;
import com.plane.llmhub.model.ModelContent;
import com.plane.llmhub.model.ModelMetric;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class LlmService {

    private final CategoryMapper categoryMapper;
    private final ModelMapper modelMapper;
    private final ContentMapper contentMapper;
    private final MetricMapper metricMapper;

    public LlmService(CategoryMapper categoryMapper,
                      ModelMapper modelMapper,
                      ContentMapper contentMapper,
                      MetricMapper metricMapper) {
        this.categoryMapper = categoryMapper;
        this.modelMapper = modelMapper;
        this.contentMapper = contentMapper;
        this.metricMapper = metricMapper;
    }

    public List<Category> getAllCategories() {
        return categoryMapper.selectAll();
    }

    public List<LlmModel> getAllModels() {
        return modelMapper.selectAll();
    }

    public List<LlmModel> getModelsByCategorySlug(String categorySlug) {
        return modelMapper.selectByCategorySlug(categorySlug);
    }

    public LlmModel getModelDetailsByKey(String modelKey) {
        LlmModel model = modelMapper.selectByModelKey(modelKey);
        if (model != null) {
            List<ModelContent> contents = contentMapper.selectByModelId(model.getId());
            List<ModelMetric> metrics = metricMapper.selectByModelId(model.getId());
            model.setContents(contents);
            model.setMetrics(metrics);
        }
        return model;
    }

    public List<ModelContent> getModelContents(Long modelId) {
        return contentMapper.selectByModelId(modelId);
    }

    public ModelContent getModelContentByType(Long modelId, String subMenuType) {
        return contentMapper.selectByModelIdAndType(modelId, subMenuType.toUpperCase());
    }

    public List<LlmModel> search(String keyword) {
        return modelMapper.searchModels(keyword);
    }

    public Map<String, Object> getWorkspaceStats() {
        Map<String, Object> stats = new HashMap<>();
        List<Category> categories = categoryMapper.selectAll();
        List<LlmModel> models = modelMapper.selectAll();
        stats.put("totalCategories", categories.size());
        stats.put("totalModels", models.size());
        stats.put("activeProviders", 6);
        stats.put("enterpriseReadyCount", models.size());
        return stats;
    }
}
