package com.plane.llmhub.model;

import java.io.Serializable;

public class ModelMetric implements Serializable {
    private static final long serialVersionUID = 1L;

    private Long id;
    private Long modelId;
    private String benchmarkName;
    private String score;
    private Integer percentVal;
    private String category;

    public ModelMetric() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getModelId() { return modelId; }
    public void setModelId(Long modelId) { this.modelId = modelId; }

    public String getBenchmarkName() { return benchmarkName; }
    public void setBenchmarkName(String benchmarkName) { this.benchmarkName = benchmarkName; }

    public String getScore() { return score; }
    public void setScore(String score) { this.score = score; }

    public Integer getPercentVal() { return percentVal; }
    public void setPercentVal(Integer percentVal) { this.percentVal = percentVal; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
}
