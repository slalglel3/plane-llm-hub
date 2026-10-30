package com.plane.llmhub.model;

import java.io.Serializable;
import java.util.List;

public class LlmModel implements Serializable {
    private static final long serialVersionUID = 1L;

    private Long id;
    private Long categoryId;
    private String categorySlug;
    private String categoryName;
    private String modelKey;
    private String name;
    private String provider;
    private String releaseDate;
    private String contextWindow;
    private String maxOutput;
    private String pricingInput;
    private String pricingOutput;
    private String badge;
    private String tagline;
    private Integer displayOrder;

    private List<ModelContent> contents;
    private List<ModelMetric> metrics;

    public LlmModel() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getCategoryId() { return categoryId; }
    public void setCategoryId(Long categoryId) { this.categoryId = categoryId; }

    public String getCategorySlug() { return categorySlug; }
    public void setCategorySlug(String categorySlug) { this.categorySlug = categorySlug; }

    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }

    public String getModelKey() { return modelKey; }
    public void setModelKey(String modelKey) { this.modelKey = modelKey; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getProvider() { return provider; }
    public void setProvider(String provider) { this.provider = provider; }

    public String getReleaseDate() { return releaseDate; }
    public void setReleaseDate(String releaseDate) { this.releaseDate = releaseDate; }

    public String getContextWindow() { return contextWindow; }
    public void setContextWindow(String contextWindow) { this.contextWindow = contextWindow; }

    public String getMaxOutput() { return maxOutput; }
    public void setMaxOutput(String maxOutput) { this.maxOutput = maxOutput; }

    public String getPricingInput() { return pricingInput; }
    public void setPricingInput(String pricingInput) { this.pricingInput = pricingInput; }

    public String getPricingOutput() { return pricingOutput; }
    public void setPricingOutput(String pricingOutput) { this.pricingOutput = pricingOutput; }

    public String getBadge() { return badge; }
    public void setBadge(String badge) { this.badge = badge; }

    public String getTagline() { return tagline; }
    public void setTagline(String tagline) { this.tagline = tagline; }

    public Integer getDisplayOrder() { return displayOrder; }
    public void setDisplayOrder(Integer displayOrder) { this.displayOrder = displayOrder; }

    public List<ModelContent> getContents() { return contents; }
    public void setContents(List<ModelContent> contents) { this.contents = contents; }

    public List<ModelMetric> getMetrics() { return metrics; }
    public void setMetrics(List<ModelMetric> metrics) { this.metrics = metrics; }
}
