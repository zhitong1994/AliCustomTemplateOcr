package com.shtx.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.http.HttpResponse;
import org.apache.http.util.EntityUtils;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.shtx.utils.HttpUtils;

@WebServlet(name = "AliOcr", value = "/AliOcr")
@SuppressWarnings("serial")
public class AliOcr extends HttpServlet{

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		doPost(request, response);
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {	
		
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");
        //从前端拿到image的64编码
        String img = request.getParameter("image");
		// 调用阿里云api
		String host = "http://ocrdiy.market.alicloudapi.com";
        String path = "/api/predict/ocr_sdt";
        String method = "POST";
        String appcode = "你自己的appcode";
        Map<String, String> headers = new HashMap<String, String>();
        headers.put("Authorization", "APPCODE " + appcode);
        headers.put("Content-Type", "application/json; charset=UTF-8");
        Map<String, String> querys = new HashMap<String, String>();

        String bodys = null;
        bodys =  "{\"image\":\""+ img +"\",\"configure\": \"{\\\"template_id\\\":\\\"你自己的模板id\\\"}\"}";
     
		try {
			HttpResponse response1 = HttpUtils.doPost(host, path, method, headers, querys, bodys);
			System.out.println(response1);
	        //得到返回的数据的字符串
	        String result = EntityUtils.toString(response1.getEntity()); 
		    System.out.println("返回的字符串:" + result);
		    //处理json字符串，提取值
		    JSONObject jsonObject = JSONObject.parseObject(result);						    
		    System.out.println("json:" + jsonObject);
		    //取出json中需要的items值
		    JSONObject json = jsonObject.getJSONObject("items");
		    System.out.println("items:" + json);

		    //返回前端
		    PrintWriter out  = response.getWriter();
		    out.print(json);
		    out.flush();
            out.close();

		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} 
	   
	}
	
	

}
