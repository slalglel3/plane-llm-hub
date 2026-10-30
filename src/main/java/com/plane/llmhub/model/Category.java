package com.plane.llmhub.model;

import java.io.Serializable;
import java.util.List;

public class Category implements Serializable {
    private static final long serialVersionUID = 1L;

    private Long id;
    private String slug;
    private String name;
    private String icon;
    private String tagline;
    private Integer displayOrder;
    private List<LlmModel> models;

    public Category() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getSlug() { return slug; }
    public void setSlug(String slug) { this.slug = slug; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getIcon() { return icon; }
    public void setIcon(String icon) { this.icon = icon; }

    public String getTagline() { return tagline; }
    public void setTagline(String tagline) { this.tagline = tagline; }

    public Integer getDisplayOrder() { return displayOrder; }
    public void setDisplayOrder(Integer displayOrder) { this.displayOrder = displayOrder; }

    public List<LlmModel> getModels() { return models; }
    public void setModels(List<LlmModel> models) { this.models = models; }
}
