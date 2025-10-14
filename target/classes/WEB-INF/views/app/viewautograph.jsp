<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String autographId = request.getParameter("id");
    // TODO: Fetch autograph details from database using this ID
%>


<main class="main-content">
    <!-- Intro Section -->
    <section class="intro">
        <h2>Uni Leaving Auto Book</h2>
        <link href="resources/ts/viewautograph.css" rel="stylesheet"/>
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&display=swap" rel="stylesheet"/>
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet"/>
        <p>Share your book with friends and collect heartfelt messages.</p>
        <img class="intro-img" src="https://lh3.googleusercontent.com/aida-public/AB6AXuCXtiBE1aJc8YtesUj-kq4c3o-zhpx3ngmjiM9JFzJR0ao4rkVO14r-HpIpnLKZmTOthLd_kTSJHopGzhrnut5_ljjiP24KWIeb7767QgYp_p_sMqMxH6UkbmBDTpo3EgQ4zMd_7TZ1LCyh_Hq8DvzQnKTmN9gGT2Nc4lkfLhljFUzEz_bpNFQ6dMMHg2V-aQElqRycXpswBmaLL_vmhq5FRTHMTsmMdSjIbnv7Jo4lr-gDMmoK1Bm4ztu9Uoo2-1gIITv3PvFb_Jnl" alt="Intro Image"/>
    </section>

    <!-- Autographs Section -->
    <section class="autographs">
        <h3>Autographs</h3>
        <div class="autograph-grid">
            <div class="autograph-item">
                <img src="https://lh3.googleusercontent.com/aida-public/AB6AXuDWeGxwKqhxXUt4rSGVlWi4VvK8iynfhIBjPgPKFtw3SOPoBG_bYhByM54xMkD6XOrYZLzVS2uD_5aUtguCjByHtLNocrNhG1UF1EiPBnqtxYEp620CGnePNI4PkVJL9LR9G9FTgVCvafWUrcY9DJqie_j2JHeA4BlQWy2-TyfKa_1eGtWc4L5MGMiEBJ7PyXZ9-PRNkjPE1OJJbhpLbk_z8NWnYT3fmDzkLWwJ9IEubm6LB0Ve7A8X98A5xtmSpMIU0TrZYQCqvljl" alt="Sarah's Message"/>
                <p>Sarah's Message</p>
            </div>
            <div class="autograph-item">
                <img src="https://lh3.googleusercontent.com/aida-public/AB6AXuAUpiUBdn09yvEo8WIAI29MN9blm1ozNBeK3K3NlOLrqzhewt2VxwYS3Yw7Gen_oeTp5pbDh7scVub-RTGMPT7yRalhU8xmJqkpgA3TBhLoRTcYNHKdG3asLXRcGhIZJA3sMVrO6F1O9vHEgEPBsIWLOSn0FkHjty26ngoFgcvUPq4XcV5NIQI4MpYWYaNIJnLrTAMc-IRKnvIq-A_BopbeTRgzik3Muh2PyTGY7_6-yGhQ_iZfoNu7f2QPt81JVI72zMwbTNLRmM-c" alt="Mark's Message"/>
                <p>Mark's Message</p>
            </div>
            <div class="autograph-item">
                <img src="https://lh3.googleusercontent.com/aida-public/AB6AXuB1ueJJbH3QUe-2RXS3qDM892zgYSEXc-yeyfHorLKsqzjyyROs3ilOFvL25M6rvWYY-4FsvK7fWD5VZXyCLv4wEshHxCfH-LQ8bI8AGAIzYV3k_f7wgWxYnSmLcFVZEI9weTvxqh1ECJgwdS_QFf_jFP7IMhziXpReCgiqzGeqij-PXLh0BLI2M8vyMExngTDdNraSd8u_inO_GpCJ0ApxuMiTKVx4djB8BxagbIvf-GBAB1ffClsO6lUUj2QHtBiLnmrdl12gJ0oM" alt="Emily's Message"/>
                <p>Emily's Message</p>
            </div>
            <div class="autograph-item">
                <img src="https://lh3.googleusercontent.com/aida-public/AB6AXuClGrPmyDTkb2-_CKa2SP1ScMzJ_ZeQ29iFRC_nbzSFHbbsdAxYupf_c5nlJH7JP34RLLlVD14Ou8tE7wQacZJRsQpZ_rfjxyCNa6akAX0weVRR7gKZlr-A8J3nE5LsKChjSFlk75vcTv6_yVQR_tM2IdHig0UvGtus9rrumrLY7JLmlnj8ovXus6TbL5DN2A4vV1EOEtsZPvhWEUkpUWgd4E4nvRh2ij7B8XaAqxHCtpeua8_tpHEt8t8cftAYk50-71KZ3yMiAIfS" alt="David's Message"/>
                <p>David's Message</p>
            </div>
        </div>
    </section>

    <!-- Invite Section -->
    <section class="invite">
        <h3>Invite Friends</h3>
        <div class="invite-box">
            <input type="text" readonly value=""/>
            <button><span class="material-icons">content_copy</span></button>
        </div>
        <button class="share-btn">Share</button>
    </section>
</main>

