//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by FernFlower decompiler)
//

package sdigital.vcpublic.config;

import java.io.File;
import java.io.IOException;
import java.net.URL;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import org.apache.commons.io.FileUtils;
import sdigital.vcpublic.home.VcHome;
import wawo.io.Os;
import wawo.util.Zip;

public class CacheUploadFilter implements Filter {
    private static final Logger logger = Logger.getLogger(CacheUploadFilter.class.getName());
    private String encoding;
    private String path;
    private String tempfilePath;
    private File file;
    private String type;
    private int maxFileSize;
    private int maxMemSize;

    public CacheUploadFilter() {
    }

    public void init(FilterConfig filterConfig) throws ServletException {
        this.encoding = filterConfig.getInitParameter("requestEncoding");
        this.path = SystemConstant.CACHE_PATH;
        this.tempfilePath = ContextListenerServlet.ROOT_PATH + SystemConstant.PATH + "/";
        this.maxFileSize = 51200000;
        this.maxMemSize = 51200000;
        if (this.encoding == null) {
            this.encoding = SystemConstant.ENCODING;
        }

        if (logger.isLoggable(Level.FINE)) {
            logger.fine("FileUploadFilter initiated successfully");
        }

    }

    public void doFilter(ServletRequest httpServletRequest, ServletResponse servletResponse, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest)httpServletRequest;
        this.file = new File(SystemConstant.CACHE_PATH + "cacheLoading.zip");
        FileUtils.copyURLToFile(new URL("http://cdn3.vouchercodes.in/cacheLoading.zip"), this.file);

        try {
            Zip.unZip(this.path, this.file.getPath());
            Os.deleteFile(this.file.getPath());
            Os.copyFile(this.path + "cacheLoading.json", this.path + "cacheLoaded.json", true);
            Os.deleteFile(this.path + "cacheLoading.json");
            VcHome.loadDataFast();
        } catch (Exception var6) {
             var6 = var6;
            logger.log(Level.SEVERE, (String)null, var6);
            throw new ServletException(var6);
        }
    }

    public void destroy() {
    }
}
