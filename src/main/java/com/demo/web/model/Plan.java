package com.demo.web.model;

public class Plan {
    private int planId;
    private String name;
    private long storageLimitBytes;
    private double priceMonthly;
    private double priceAnnual;
    private int maxMembers;
    private String description;
    private int memoryLimit;

    public Plan() {
    }

    public Plan(int planId, String name, long storageLimitBytes, double priceMonthly, double priceAnnual,
            int maxMembers, String description, int memoryLimit) {
        this.planId = planId;
        this.name = name;
        this.storageLimitBytes = storageLimitBytes;
        this.priceMonthly = priceMonthly;
        this.priceAnnual = priceAnnual;
        this.maxMembers = maxMembers;
        this.description = description;
        this.memoryLimit = memoryLimit;
    }

    public int getPlanId() {
        return planId;
    }

    public void setPlanId(int planId) {
        this.planId = planId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public long getStorageLimitBytes() {
        return storageLimitBytes;
    }

    public void setStorageLimitBytes(long storageLimitBytes) {
        this.storageLimitBytes = storageLimitBytes;
    }

    public double getPriceMonthly() {
        return priceMonthly;
    }

    public void setPriceMonthly(double priceMonthly) {
        this.priceMonthly = priceMonthly;
    }

    public double getPriceAnnual() {
        return priceAnnual;
    }

    public void setPriceAnnual(double priceAnnual) {
        this.priceAnnual = priceAnnual;
    }

    public int getMaxMembers() {
        return maxMembers;
    }

    public void setMaxMembers(int maxMembers) {
        this.maxMembers = maxMembers;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getMemoryLimit() {
        return memoryLimit;
    }

    public void setMemoryLimit(int memoryLimit) {
        this.memoryLimit = memoryLimit;
    }
}
