//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by FernFlower decompiler)
//

package sdigital.pl.products.domains;

import org.apache.solr.client.solrj.beans.Field;

public class Product {
    @Field
    private String imageurl;
    @Field
    private String name;
    @Field
    private Float price;
    @Field
    private String priceC;
    @Field
    private String categorypath;
    @Field
    private String producturl;
    @Field
    private String category;
    @Field
    private String manu;
    @Field
    private String id;
    @Field
    private Integer version;
    @Field
    private String description;
    @Field("discount_i")
    private Integer discountI;
    @Field("mrp_d")
    private Double mrpD;
    @Field("store")
    private String store;
    @Field
    private Boolean inStock;

    public Product() {
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public void setDiscountI(Integer discountI) {
        this.discountI = discountI;
    }

    public void setMrpD(Double mrpD) {
        this.mrpD = mrpD;
    }

    public void setInStock(Boolean inStock) {
        this.inStock = inStock;
    }

    public String getDescription() {
        return this.description;
    }

    public float getDiscountI() {
        return (float)this.discountI;
    }

    public Double getMrpD() {
        return this.mrpD;
    }

    public Boolean getInStock() {
        return this.inStock;
    }

    public String getImageurl() {
        return this.imageurl;
    }

    public void setImageurl(String imageurl) {
        this.imageurl = imageurl;
    }

    public String getName() {
        return this.name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Float getPrice() {
        return this.price;
    }

    public void setPrice(Float price) {
        this.price = price;
    }

    public String getPriceC() {
        return this.priceC;
    }

    public void setPriceC(String priceC) {
        this.priceC = priceC;
    }

    public String getCategorypath() {
        return this.categorypath;
    }

    public void setCategorypath(String categorypath) {
        this.categorypath = categorypath;
    }

    public String getProducturl() {
        return this.producturl;
    }

    public void setProducturl(String producturl) {
        this.producturl = producturl;
    }

    public String getCategory() {
        return this.category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getManu() {
        return this.manu;
    }

    public void setManu(String manu) {
        this.manu = manu;
    }

    public String getId() {
        return this.id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public Integer getVersion() {
        return this.version;
    }

    public void setVersion(Integer version) {
        this.version = version;
    }

    public String getStore() {
        return this.store;
    }

    public void setStore(String store) {
        this.store = store;
    }
}
