package com.plane.llmhub.model;

import java.io.Serializable;

public class ModelContent implements Serializable {
    private static final long serialVersionUID = 1L;

    private Long id;
    private Long modelId;
    private String subMenuType; // OVERVIEW, USAGE, PROS_CONS, BENCHMARKS, LINKS
    private String title;
    private String contentBody;
    private String metaJson;

    public ModelContent() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getModelId() { return modelId; }
    public void setModelId(Long modelId) { this.modelId = modelId; }

    public String getSubMenuType() { return subMenuType; }
    public void setSubMenuType(String subMenuType) { this.subMenuType = subMenuType; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getContentBody() { return contentBody; }
    public void setContentBody(String contentBody) { this.contentBody = contentBody; }

    public String getMetaJson() { return metaJson; }
    public void setMetaJson(String metaJson) { this.metaJson = metaJson; }
}
