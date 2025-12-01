<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<jsp:include page="../public/header2.jsp" />

<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/memories.css">

<div class="page-wrapper">
    <main class="main-content">
        <div class="tab-nav">
            <button class="active">Memories</button>
            <button onclick="window.location.href='/collabmemories'">Collab Memories</button>
            <button onclick="window.location.href='/memoryrecap'">Memory Recap</button>
        </div>

        <div class="search-filters" style="margin: 15px 0;">
            <button class="floating-btn" style="padding: 10px 20px;">
                <a href="/creatememory" style="color: white; text-decoration: none;">
                    Add Memory
                </a>
            </button>
        </div>

        <div class="memories-grid">
            <c:choose>
                <c:when test="${empty memories}">
                    <div style="grid-column: 1/-1; text-align: center; padding: 60px; color: #888;">
                        <h3>No memories yet</h3>
                        <p>Start creating your first memory!</p>
                        <a href="/creatememory" class="floating-btn">Create Memory</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="memory" items="${memories}">
                        <c:set var="coverUrl" value="${requestScope['cover_' += memory.memoryId]}" />
                        <c:set var="finalCover" value="${not empty coverUrl ? coverUrl : pageContext.request.contextPath += '/resources/images/default-memory.jpg'}" />

                        <div class="memory-card" onclick="location.href='/memoryview?id=${memory.memoryId}'">
                            <div class="memory-image" style="background-image: url('${finalCover}')">
                            </div>
                            <div class="memory-content">
                                <h3 class="memory-title">${memory.title}</h3>
                                <p class="memory-date">
                                    <fmt:formatDate value="${memory.createdTimestamp}" pattern="MMMM d, yyyy"/>
                                </p>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </main>

    <jsp:include page="../public/footer.jsp" />
</div>