//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by FernFlower decompiler)
//

package sdigital.pl.products.utilities;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.net.URL;
import java.text.Normalizer;
import java.text.Normalizer.Form;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Set;
import javax.imageio.ImageIO;
import javax.servlet.ServletContext;
import org.apache.solr.client.solrj.SolrQuery;
import org.apache.solr.client.solrj.SolrQuery.ORDER;
import org.apache.solr.client.solrj.response.FacetField;
import org.apache.solr.client.solrj.response.FieldStatsInfo;
import org.apache.solr.client.solrj.response.QueryResponse;
import sdigital.pl.products.domains.Breadcrumb;
import sdigital.pl.products.domains.Product;
import sdigital.pl.products.domains.ProductBrand;
import sdigital.pl.products.domains.ProductCategory;
import sdigital.vcpublic.config.SystemConstant;
import sdigital.vcpublic.home.Domains;
import sdigital.vcpublic.home.FeedMeta;
import sdigital.vcpublic.home.VcHome;
import sdigital.vcpublic.home.VcHomeLoader;
import wawo.util.PropertyUtil;
import wawo.util.StringUtil;

public class SolrUtils {
    public SolrUtils() {
    }

    public static List<ProductCategory> processSearchCategories(String domainId, QueryResponse rsp) {
        List<ProductCategory> catList = new ArrayList();
        List<FacetField.Count> categories = rsp.getFacetField("categorypath") != null ? rsp.getFacetField("categorypath").getValues() : null;
        VcHome home = VcHome.instance();
        if (categories == null) {
            return catList;
        } else {
            Iterator var5 = categories.iterator();

            while(true) {
                FacetField.Count category;
                do {
                    if (!var5.hasNext()) {
                        return catList;
                    }

                    category = (FacetField.Count)var5.next();
                } while(category.getCount() <= 1L);

                String[] seoArray = category.getName().split("\\|");
                String catName = seoArray[seoArray.length - 1];
                String seo = "";

                for(int i = 0; i < seoArray.length; ++i) {
                    seo = seo + "/" + generateSeoUrl(seoArray[i]);
                }

                long count = category.getCount() - 1L;
                ProductCategory catUpdate = new ProductCategory();
                catUpdate.setName(toDisplayCase(catName));
                catUpdate.setSeo(seo);
                catUpdate.setCount(count);
                catList.add(catUpdate);
                catUpdate = null;
                home.setProductCatSeoAdd(domainId, seo.substring(1), catName.toLowerCase());
                home.setProductCatPathAdd(domainId, seo.substring(1), category.getName().toLowerCase());
            }
        }
    }

    public static List<ProductCategory> processBrandCategories(String domainId, QueryResponse rsp, String brandName, long price_min, long price_max, String sort, String store) {
        List<ProductCategory> catList = new ArrayList();
        List<FacetField.Count> categories = rsp.getFacetField("categorypath") != null ? rsp.getFacetField("categorypath").getValues() : null;
        VcHome home = VcHome.instance();
        if (categories == null) {
            return catList;
        } else {
            Iterator var12 = categories.iterator();

            while(true) {
                FacetField.Count category;
                do {
                    if (!var12.hasNext()) {
                        return catList;
                    }

                    category = (FacetField.Count)var12.next();
                } while(category.getCount() <= 1L);

                String[] seoArray = category.getName().split("\\|");
                brandName = brandName.split("\\|")[0].trim();
                String catName = seoArray[seoArray.length - 1];
                String seo = "";

                for(int i = 0; i < seoArray.length; ++i) {
                    seo = seo + "/" + generateSeoUrl(seoArray[i]);
                }

                long count = category.getCount() - 1L;
                ProductCategory catUpdate = new ProductCategory();
                catUpdate.setName(toDisplayCase(catName));
                catUpdate.setSeo(seo);
                catUpdate.setCount(count);
                catUpdate.setSeo(addParameters("/" + generateSeoUrl(brandName) + seo, price_min, price_max, sort, store));
                catList.add(catUpdate);
                catUpdate = null;
                home.setProductCatSeoAdd(domainId, seo.substring(1), catName.toLowerCase());
                home.setProductCatPathAdd(domainId, seo.substring(1), category.getName().toLowerCase());
            }
        }
    }

    public static List<ProductCategory> processCategories(String domainId, QueryResponse rsp, String name, String brandName, long price_min, long price_max, String sort, String store) {
        List<ProductCategory> catList = new ArrayList();
        List<FacetField.Count> categories = rsp.getFacetField("categorypath") != null ? rsp.getFacetField("categorypath").getValues() : null;
        VcHome home = VcHome.instance();
        if (categories == null) {
            return updateCategoryList(catList, name);
        } else {
            Iterator var13 = categories.iterator();

            while(true) {
                FacetField.Count category;
                do {
                    if (!var13.hasNext()) {
                        return updateCategoryList(catList, name);
                    }

                    category = (FacetField.Count)var13.next();
                } while(category.getCount() <= 1L);

                String[] seoArray = category.getName().split("\\|");
                String catName = "";
                String catPath = "";
                String seo = "";
                long count = 0L;

                for(int i = 0; i < seoArray.length; ++i) {
                    int j;
                    ProductCategory catUpdate;
                    if (name.equals(seoArray[i]) && i < seoArray.length - 1) {
                        catPath = "";
                        seo = "";
                        catName = seoArray[i + 1];

                        for(j = 0; j <= i + 1; ++j) {
                            catPath = !"".equals(catPath) ? catPath + "|" + seoArray[j] : seoArray[j];
                            seo = seo + "/" + generateSeoUrl(seoArray[j]);
                        }

                        count = category.getCount() - 1L;
                        catUpdate = new ProductCategory();
                        catUpdate.setName(catName);
                        if (brandName != null) {
                            brandName = brandName.split("\\|")[0].trim();
                            catUpdate.setSeo(addParameters("/" + generateSeoUrl(brandName) + seo, price_min, price_max, sort, store));
                            home.setProductBrandSeoAdd(domainId, generateSeoUrl(brandName) + seo, brandName + " | " + catName);
                        } else {
                            catUpdate.setSeo(addParameters(seo, price_min, price_max, sort, store));
                        }

                        catUpdate.setCount(count);
                        catList.add(catUpdate);
                        catUpdate = null;
                        home.setProductCatSeoAdd(domainId, seo.substring(1), catName.toLowerCase());
                        home.setProductCatPathAdd(domainId, seo.substring(1), catPath.toLowerCase());
                    } else if (i == seoArray.length - 1 && name.equals(seoArray[i])) {
                        catPath = "";
                        seo = "";
                        catName = seoArray[i];

                        for(j = 0; j <= i; ++j) {
                            catPath = !"".equals(catPath) ? catPath + "|" + seoArray[j] : seoArray[j];
                            seo = seo + "/" + generateSeoUrl(seoArray[j]);
                        }

                        count = category.getCount();
                        catUpdate = new ProductCategory();
                        catUpdate.setName(catName);
                        if (brandName != null) {
                            brandName = brandName.split("\\|")[0].trim();
                            catUpdate.setSeo(addParameters("/" + generateSeoUrl(brandName) + seo, price_min, price_max, sort, store));
                            home.setProductBrandSeoAdd(domainId, generateSeoUrl(brandName) + seo, brandName + " | " + catName);
                        } else {
                            catUpdate.setSeo(addParameters(seo, price_min, price_max, sort, store));
                        }

                        catUpdate.setCount(count);
                        catList.add(catUpdate);
                        catUpdate = null;
                        home.setProductCatSeoAdd(domainId, seo.substring(1), catName.toLowerCase());
                        home.setProductCatPathAdd(domainId, seo.substring(1), catPath);
                    }
                }
            }
        }
    }

    public static List<ProductBrand> processCategoryBrands(String domainId, QueryResponse rsp, String catSeo, long price_min, long price_max, String sort, String store) {
        List<ProductBrand> brList = new ArrayList();
        List<FacetField.Count> brands = rsp.getFacetField("manu_exact") != null ? rsp.getFacetField("manu_exact").getValues() : null;
        VcHome home = VcHome.instance();
        if (brands == null) {
            return brList;
        } else {
            Iterator var12 = brands.iterator();

            while(true) {
                FacetField.Count brand;
                do {
                    if (!var12.hasNext()) {
                        return brList;
                    }

                    brand = (FacetField.Count)var12.next();
                } while(brand.getCount() <= 1L);

                ProductBrand br = new ProductBrand();
                br.setName(brand.getName());
                String brandName = brand.getName().split("\\|")[0].trim();
                br.setSeo(addParameters("/" + generateSeoUrl(brandName) + "/" + catSeo, price_min, price_max, sort, store));
                br.setCount(brand.getCount() - 1L);
                String var10000 = generateSeoUrl(brandName);
                String seoUrl = var10000 + "/" + catSeo;
                String[] seoUrlArray = seoUrl.split("/");
                String currentUrl = "";
                String catUrl = "";

                for(int i = 0; i < seoUrlArray.length; ++i) {
                    currentUrl = currentUrl + "/" + seoUrlArray[i];
                    if (i > 0) {
                        catUrl = catUrl + "/" + seoUrlArray[i];
                        home.setProductBrandSeoAdd(domainId, currentUrl.substring(1), brandName + " | " + getProductCatSeo(domainId, catUrl.substring(1)));
                    } else {
                        home.setProductBrandSeoAdd(domainId, currentUrl.substring(1), brandName);
                    }
                }

                brList.add(br);
                br = null;
            }
        }
    }

    public static List<ProductBrand> processBrands(String domainId, QueryResponse rsp, long price_min, long price_max, String sort, String store) {
        List<ProductBrand> brList = new ArrayList();
        List<FacetField.Count> brands = rsp.getFacetField("manu_exact") != null ? rsp.getFacetField("manu_exact").getValues() : null;
        VcHome home = VcHome.instance();
        if (brands == null) {
            return brList;
        } else {
            Iterator var11 = brands.iterator();

            while(true) {
                FacetField.Count brand;
                do {
                    if (!var11.hasNext()) {
                        return brList;
                    }

                    brand = (FacetField.Count)var11.next();
                } while(brand.getCount() <= 1L);

                boolean flag = true;
                Iterator var14 = brList.iterator();

                ProductBrand tempBrand;
                while(var14.hasNext()) {
                    tempBrand = (ProductBrand)var14.next();
                    if (tempBrand.getName().equalsIgnoreCase(brand.getName())) {
                        flag = false;
                        break;
                    }
                }

                tempBrand = new ProductBrand();
                tempBrand.setName(brand.getName());
                tempBrand.setSeo(addParameters("/" + generateSeoUrl(brand.getName()), price_min, price_max, sort, store));
                tempBrand.setCount(brand.getCount() - 1L);
                String seoUrl = generateSeoUrl(brand.getName());
                home.setProductBrandSeoAdd(domainId, seoUrl, brand.getName());
                brList.add(tempBrand);
                var14 = null;
            }
        }
    }

    public static List<String> processStores(QueryResponse rsp) {
        List<String> stList = new ArrayList();
        List<FacetField.Count> stores = rsp.getFacetField("store") != null ? rsp.getFacetField("store").getValues() : null;
        if (stores != null) {
            Iterator var3 = stores.iterator();

            while(var3.hasNext()) {
                FacetField.Count store = (FacetField.Count)var3.next();
                stList.add(store.getName());
            }
        }

        return stList;
    }

    public static String generateQuery(String name) {
        return name.replaceAll("\\s", "*") + "*";
    }

    public static String generateSeoUrl(String name) {
        return Normalizer.normalize(name.toLowerCase(), Form.NFD).replaceAll("\\p{InCombiningDiacriticalMarks}+", "").replaceAll("[^\\p{Alnum}]+", "-");
    }

    public static List<Breadcrumb> getBreadcrumb(String domainId, String page) {
        List<Breadcrumb> breadcrumbs = new ArrayList();
        String[] pagesArray = page.split("/");
        String currentUrl = "";
        String catCurrentUrl = "";
        String name = null;

        for(int i = 0; i < pagesArray.length; ++i) {
            currentUrl = currentUrl + "/" + pagesArray[i];
            if (i > 0) {
                catCurrentUrl = catCurrentUrl + "/" + pagesArray[i];
            }

            name = getProductBrandSeo(domainId, currentUrl.substring(1));
            if (name == null) {
                name = getProductCatSeo(domainId, currentUrl.substring(1));
            } else if (name != null && i > 0) {
                name = getProductCatSeo(domainId, catCurrentUrl.substring(1));
            }

            if (name != null) {
                breadcrumbs.add(new Breadcrumb(currentUrl, toDisplayCase(name)));
            } else {
                breadcrumbs.add(new Breadcrumb((String)null, "Not Found"));
            }
        }

        return breadcrumbs;
    }

    public static String getProductCatSeo(String domainId, String page) {
        VcHome home = VcHome.instance();
        SolrDao<Product> solrDao = new SolrDao(domainId);
        String catName = home.getProductCatSeo(domainId, page);
        if (catName == null) {
            String[] pageArray = page.split("/");
            if (home.getProductCatSeo(domainId, pageArray[0]) == null) {
                return null;
            }

            String var10000 = home.getProductCatSeo(domainId, pageArray[0]);
            String pathQuery = "*" + var10000.replaceAll("\\s", "*");

            for(int i = 1; i < pageArray.length; ++i) {
                pathQuery = pathQuery + "*" + pageArray[i].replaceAll("-", "*");
            }

            pathQuery = pathQuery + "*";
            QueryResponse rsp = solrDao.readForPath(pathQuery);
            List<Product> products = rsp.getBeans(Product.class);
            if (products == null || products.isEmpty()) {
                return null;
            }

            String path = ((Product)products.get(0)).getCategorypath();
            String[] pathArray = path.split("\\|");
            catName = pathArray[pageArray.length - 1].toLowerCase();
            String catPath = "";

            for(int i = 0; i <= pageArray.length - 1; ++i) {
                catPath = !"".equals(catPath) ? catPath + "|" + pathArray[i] : pathArray[i];
            }

            home.setProductCatSeoAdd(domainId, page, catName.toLowerCase());
            home.setProductCatPathAdd(domainId, page, catPath.toLowerCase());
        }

        return catName;
    }

    public static String getProductBrandSeo(String domainId, String page) {
        VcHome home = VcHome.instance();
        SolrDao<Product> solrDao = new SolrDao(domainId);
        String brandName = home.getProductBrandSeo(domainId, page);
        if (brandName == null) {
            String[] bPageArray = page.split("/");
            brandName = home.getProductBrandSeo(domainId, bPageArray[0]);
            String catPage;
            if (brandName == null) {
                catPage = toDisplayCase(bPageArray[0].replaceAll("-", " "));
                QueryResponse rsp = solrDao.readForBrand(catPage);
                List<Product> products = rsp.getBeans(Product.class);
                if (products == null || products.isEmpty()) {
                    return null;
                }

                brandName = ((Product)products.get(0)).getManu();
            }

            if (bPageArray.length == 1) {
                return brandName;
            }

            catPage = "";

            for(int i = 1; i < bPageArray.length; ++i) {
                catPage = catPage + "/" + bPageArray[i];
            }

            page = catPage.substring(1);
            String catName = home.getProductCatSeo(domainId, page);
            if (catName == null) {
                String[] pageArray = page.split("/");
                if (home.getProductCatSeo(domainId, pageArray[0]) == null) {
                    return null;
                }

                String var10000 = home.getProductCatSeo(domainId, pageArray[0]);
                String pathQuery = "*" + var10000.replaceAll("\\s", "*");

                for(int i = 1; i < pageArray.length; ++i) {
                    pathQuery = pathQuery + "*" + pageArray[i].replaceAll("-", "*");
                }

                pathQuery = pathQuery + "*";
                QueryResponse rsp = solrDao.readForPath(pathQuery);
                List<Product> products = rsp.getBeans(Product.class);
                if (products == null || products.isEmpty()) {
                    return null;
                }

                String path = ((Product)products.get(0)).getCategorypath();
                String[] pathArray = path.split("\\|");
                catName = pathArray[pageArray.length - 1];
                String catPath = "";

                for(int i = 0; i <= pageArray.length - 1; ++i) {
                    catPath = !"".equals(catPath) ? catPath + "|" + pathArray[i] : pathArray[i];
                }

                home.setProductCatSeoAdd(domainId, page, catName.toLowerCase());
                home.setProductCatPathAdd(domainId, page, catPath.toLowerCase());
                home.setProductBrandSeoAdd(domainId, bPageArray[0] + "/" + page, brandName + " | " + catName);
            } else {
                home.setProductBrandSeoAdd(domainId, bPageArray[0] + "/" + page, brandName + " | " + catName);
            }
        }

        return brandName;
    }

    private static List<ProductCategory> updateCategoryList(List<ProductCategory> list, String catName) {
        List<ProductCategory> updated = new ArrayList();
        Set<String> uniqueList = new HashSet();
        Iterator var4 = list.iterator();

        while(var4.hasNext()) {
            ProductCategory p = (ProductCategory)var4.next();
            uniqueList.add(p.getName());
        }

        uniqueList.remove(catName);
        var4 = uniqueList.iterator();

        while(var4.hasNext()) {
            String name = (String)var4.next();
            long count = 0L;
            String seo = "";
            Iterator var9 = list.iterator();

            ProductCategory catInner;
            while(var9.hasNext()) {
                catInner = (ProductCategory)var9.next();
                if (name.equals(catInner.getName())) {
                    count += catInner.getCount();
                    seo = catInner.getSeo();
                }
            }

            catInner = new ProductCategory();
            catInner.setSeo(seo);
            catInner.setName(toDisplayCase(name));
            catInner.setCount(count);
            updated.add(catInner);
        }

        return updated;
    }

    public static String toDisplayCase(String s) {
        String ACTIONABLE_DELIMITERS = " '-/";
        StringBuilder sb = new StringBuilder();
        boolean capNext = true;
        char[] var4 = s.toCharArray();
        int var5 = var4.length;

        for(int var6 = 0; var6 < var5; ++var6) {
            char c = var4[var6];
            c = capNext ? Character.toUpperCase(c) : Character.toLowerCase(c);
            sb.append(c);
            capNext = " '-/".indexOf(c) >= 0;
        }

        return sb.toString();
    }

    public static SolrQuery.ORDER getSortOrder(String s) {
        SolrQuery.ORDER order = null;
        switch (s) {
            case "asc" -> order = ORDER.asc;
            case "desc" -> order = ORDER.desc;
            default -> order = ORDER.desc;
        }

        return order;
    }

    public static BufferedImage getImageFromUrl(String imageId, ServletContext cntx) {
        BufferedImage output = null;

        String filename;
        File imgPath;
        try {
            if (imageId != null) {
                URL url = new URL(imageId);
                output = ImageIO.read(url);
            } else {
                filename = cntx.getRealPath(SystemConstant.PATH + "images/no-image.jpg");
                imgPath = new File(filename);
                output = ImageIO.read(imgPath);
            }

            return output;
        } catch (MalformedURLException var9) {
            try {
                filename = cntx.getRealPath(SystemConstant.PATH + "images/no-image.jpg");
                imgPath = new File(filename);
                output = ImageIO.read(imgPath);
                return output;
            } catch (IOException var7) {
                return output;
            }
        } catch (IOException var10) {
            try {
                filename = cntx.getRealPath(SystemConstant.PATH + "images/no-image.jpg");
                imgPath = new File(filename);
                output = ImageIO.read(imgPath);
                return output;
            } catch (IOException var8) {
                return output;
            }
        }
    }

    private static String addParameters(String url, long price_min, long price_max, String sort, String store) {
        if (price_max > 0L) {
            if (url.contains("?")) {
                url = url + "&price_min=" + price_min;
            } else {
                url = url + "?price_min=" + price_min;
            }
        }

        if (price_max > 0L) {
            if (url.contains("?")) {
                url = url + "&price_max=" + price_max;
            } else {
                url = url + "?price_max=" + price_max;
            }
        }

        if (sort != null) {
            if (url.contains("?")) {
                url = url + "&sort=" + sort;
            } else {
                url = url + "?sort=" + sort;
            }
        }

        if (store != null) {
            if (url.contains("?")) {
                url = url + "&store=" + store;
            } else {
                url = url + "?store=" + store;
            }
        }

        return url;
    }

    public static FeedMeta getFeedMeta(String domainId, String key, String flag) {
        VcHome home = VcHome.instance();
        Map<String, FeedMeta> feedMetaMap = home.getFeedMetaByDomainId(domainId);
        FeedMeta feedMeta = feedMetaMap != null ? (FeedMeta)feedMetaMap.get(key) : null;
        String title = "";
        String keywords = "";
        String description = "";

        try {
            InputStream ins = null;
            ins = VcHomeLoader.class.getResourceAsStream("/feedmeta.properties");
            Properties feedProperties = PropertyUtil.getProperties(ins, "UTF-8");
            String proBrand = getProductBrandSeo(domainId, key);
            String proCat = getProductCatSeo(domainId, key);
            String name = proBrand == null ? (proCat == null ? "" : proCat) : proBrand;
            title = feedProperties.getProperty("title").replace("#name", name);
            keywords = feedProperties.getProperty("keywords").replace("#name", name);
            description = feedProperties.getProperty("description").replace("#name", name);
            ins.close();
        } catch (IOException var14) {
        }

        if ((feedMeta == null || feedMeta.getContent() == null || "".equals(feedMeta.getContent())) && "FEED".equals(flag)) {
            feedMeta = new FeedMeta();
            feedMeta.setIndexmeta("N");
            feedMeta.setTitle(title);
            feedMeta.setMetaKeyword(keywords);
            feedMeta.setMetaDescription(description);
        }

        if (null != feedMeta && (null == feedMeta.getTitle() || feedMeta.getTitle().isEmpty())) {
            feedMeta.setTitle(title);
        }

        if (null != feedMeta && (null == feedMeta.getMetaKeyword() || feedMeta.getMetaKeyword().isEmpty())) {
            feedMeta.setMetaKeyword(keywords);
        }

        if (null != feedMeta && (null == feedMeta.getMetaDescription() || feedMeta.getMetaDescription().isEmpty())) {
            feedMeta.setMetaDescription(description);
        }

        return feedMeta;
    }

    public static String getMetaImage(String domainId, String key) {
        VcHome home = VcHome.instance();
        Map<String, FeedMeta> feedMetaMap = home.getFeedMetaByDomainId(domainId);
        FeedMeta feedMeta = feedMetaMap != null ? (FeedMeta)feedMetaMap.get(key) : null;
        return feedMeta != null && feedMeta.getImage() != null ? feedMeta.getImage() : "/images/no-image.jpg";
    }

    public static List<ProductBrand> getSimilarBrand(String domainId, String brand, long price_min, long price_max, String sort, String store) {
        VcHome home = VcHome.instance();
        List<ProductBrand> similarBrand = new ArrayList();
        SolrDao<Product> solrDao = new SolrDao(domainId);
        QueryResponse rsp = solrDao.readAllCategoryOfBrand(brand);
        List<FacetField.Count> cates = rsp.getFacetField("category") != null ? rsp.getFacetField("category").getValues() : null;
        Iterator var13 = cates.iterator();

        label65:
        while(var13.hasNext()) {
            FacetField.Count cat = (FacetField.Count)var13.next();
            if (similarBrand.size() >= Integer.parseInt(SystemConstant.MAX_SIMILAR_BRAND)) {
                break;
            }

            if (cat.getCount() > 10L) {
                rsp = solrDao.readAllBrandOfCategory(cat.getName());
                List<FacetField.Count> brands = rsp.getFacetField("manu_exact") != null ? rsp.getFacetField("manu_exact").getValues() : null;
                Iterator var16 = brands.iterator();

                while(true) {
                    FacetField.Count br;
                    do {
                        do {
                            if (!var16.hasNext()) {
                                continue label65;
                            }

                            br = (FacetField.Count)var16.next();
                            if (similarBrand.size() >= Integer.parseInt(SystemConstant.MAX_SIMILAR_BRAND)) {
                                continue label65;
                            }
                        } while(br.getCount() <= 10L);
                    } while(brand.equalsIgnoreCase(br.getName()));

                    boolean flag = true;
                    Iterator var19 = similarBrand.iterator();

                    ProductBrand brp;
                    while(var19.hasNext()) {
                        brp = (ProductBrand)var19.next();
                        if (brp.getName().equalsIgnoreCase(br.getName())) {
                            flag = false;
                            break;
                        }
                    }

                    if (flag) {
                        brp = new ProductBrand();
                        brp.setName(br.getName());
                        brp.setSeo(addParameters("/" + generateSeoUrl(br.getName()), price_min, price_max, sort, store));
                        brp.setCount(br.getCount() - 1L);
                        home.setProductBrandSeoAdd(domainId, generateSeoUrl(br.getName()), br.getName());
                        similarBrand.add(brp);
                    }
                }
            }
        }

        return similarBrand;
    }

    public static String getPathFromUrl(String url) {
        String path = "";
        if (!StringUtil.isEmpty(url)) {
            int len;
            if (url.contains("http://")) {
                url = url.substring(7);
                len = url.indexOf(47, 1);
                if (len > 0) {
                    path = url.substring(len + 1, url.length());
                }
            } else if (url.contains("https://")) {
                url = url.substring(8);
                len = url.indexOf(47, 1);
                if (len > 0) {
                    path = url.substring(len + 1, url.length());
                }
            }
        }

        return path;
    }

    public static double getMinPrice(QueryResponse rsp) {
        if (null != rsp && null != rsp.getFieldStatsInfo()) {
            FieldStatsInfo info = (FieldStatsInfo)rsp.getFieldStatsInfo().get("price");
            return info.getMin() != null ? (Double)info.getMin() : 0.0;
        } else {
            return 0.0;
        }
    }

    public static double getMaxPrice(QueryResponse rsp) {
        if (null != rsp && null != rsp.getFieldStatsInfo()) {
            FieldStatsInfo info = (FieldStatsInfo)rsp.getFieldStatsInfo().get("price");
            return info.getMax() != null ? (Double)info.getMax() : 0.0;
        } else {
            return 0.0;
        }
    }

    public static int getNoOfPages(QueryResponse rsp) {
        return null != rsp && null != rsp.getResults() ? (int)Math.ceil((double)rsp.getResults().getNumFound() * 1.0 / 20.0) : 0;
    }

    public static long getTotalRecord(QueryResponse rsp) {
        if (null != rsp && null != rsp.getResults()) {
            return rsp.getResults().getNumFound() > 0L ? rsp.getResults().getNumFound() - 1L : rsp.getResults().getNumFound();
        } else {
            return 0L;
        }
    }

    public static List<ProductCategory> sortOnPrirityByCat(String domainId, List<ProductCategory> processCategories) {
        if (processCategories != null) {
            VcHome home = VcHome.instance();
            processCategories.sort((o1, o2) -> {
                return home.getProductCatPriority(domainId, o1.getSeo()).compareTo(home.getProductCatPriority(domainId, o2.getSeo()));
            });
            return processCategories;
        } else {
            return null;
        }
    }

    public static List<ProductBrand> sortOnPrirityByBra(String domainId, List<ProductBrand> processBrands) {
        if (processBrands != null) {
            VcHome home = VcHome.instance();
            processBrands.sort((o1, o2) -> {
                return home.getProductBraPriority(domainId, o1.getSeo()).compareTo(home.getProductBraPriority(domainId, o2.getSeo()));
            });
            return processBrands;
        } else {
            return null;
        }
    }

    public static List<ProductCategory> sortOnPrirityByCatBra(String domainId, List<ProductCategory> processCategories) {
        if (processCategories != null) {
            VcHome home = VcHome.instance();
            processCategories.sort((o1, o2) -> {
                return home.getProductCatBraPriority(domainId, o1.getSeo()).compareTo(home.getProductCatBraPriority(domainId, o2.getSeo()));
            });
            return processCategories;
        } else {
            return null;
        }
    }

    public static long getTotalSearchRecord(Domains domain, String search) {
        if (!"".equals(search) && "FEED".equals(domain.getThemeType())) {
            SolrDao<Product> solrDao = new SolrDao(domain.getId());
            return solrDao.searchProductCount(search);
        } else {
            return 0L;
        }
    }
}
