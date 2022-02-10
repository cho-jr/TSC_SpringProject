package com.spring.cjs2108_cjr.interceptor;

import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

public class TicketingInterceptor extends HandlerInterceptorAdapter {
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		HttpSession session = request.getSession();
		String sNick = session.getAttribute("sNick")==null ? "": (String)session.getAttribute("sNick");
		if(sNick.equals("")) {
			RequestDispatcher dispatcher = request.getRequestDispatcher("/msg/pleaseLogin");
			dispatcher.forward(request, response);
			return false;
		}
		return true;
	}

}
