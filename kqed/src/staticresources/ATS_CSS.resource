/* global */

/* *{
	margin: 0;
	padding: 0;
} */


body,p,div,ul,ol,li,h1,h2,h3,h4,h5,h6,tbody,thead,tfoot,a,form,input,textarea,select,object,hr {
	margin: 0;
	padding: 0;
}

img {
    margin-left:0;
    margin-top:0;
    padding-left:0;
    padding-top:0;
}

html {
	height: 100%;
	min-height: 100%;
}

body {
	height: 100%;
	min-height: 100%;
	background: #f1f1f1;
	font-family: Arial, Helvetica, sans-serif;
	font-size: 14px;
	line-height: 21px;
	color: #000000;
}
.table {
	border: 1px solid #78A2B2;
	border-collapse: separate;
	background: #f1f1f1;
	position: relative;
	top: 5px;
	/*width: 640px;*/
	width: 98%;
}

.tr {
	border: 1px solid #78A2B2;
}

.td {
	background: #f1f1f1;
	border: 0px;
	/*border-right: 1px solid #f1f1f1;
	border-top: 1px solid #f1f1f1;*/
	padding: 2px 5px;
	text-align: left;
	/*color: #272727;*/
}


.th {
	border: 1px solid;
	background: #B7CED6;
	border-right: 1px solid #78A2B2;
	text-align: left;
	padding: 2px 5px;
}

body.classic {
	background: url(../images2/bg_body_gray.gif) repeat-y 50% 0 #e2e2e2;
}

.popoutMedia {
	background: #f1f1f1;
}

h1 {
	font-size: 24px;
	line-height: 29px;
}

h2 {
	font-size: 16px;
	line-height: 24px;
}

h3 {
	font-size: 12px;
	line-height: 18px;
}

ul {
	list-style: disc;
	text-indent: 0;
	margin-left: 13px;
	
}

ul ul {
	margin: 5px 0;
}

ol {
	text-indent: 0;
	margin-left: 20px;
}

li {
	line-height: 18px;
}

a {
	color: #005689;
	text-decoration: none;
	cursor: pointer;
}

a:hover, a.active {
	text-decoration: underline;
}

img {
	border: none;
}

p {
	padding-bottom: 13px;
}

.login_table {
	position: relative;
	right: 600px;
}

.clear {
	clear: both;
}

.clearAll {
	clear: both;
	width: 100%;
	height: 0px;
	overflow: hidden;
	display: block;
}

.left {
	float: left;
}

.right {
	float: right;
}

.alignLeft {
	text-align: left;
}

.alignCenter {
	text-align: center;
}

.alignRight {
	text-align: right;
}

.hidden {
	display: none;
}

.imgLeft {
	margin-right: 10px;
	margin-bottom: 10px;
	float: left;
}

.imgLeft1 {
	margin-right: 10px;
	margin-left: 10px;
	margin-bottom: 10px;
	float: left;
}

.imgRight {
	margin-left: 10px;
	margin-bottom: 10px;
	float: right;
}

label {
	font-weight: bold;
	font-size: 11px;
}

/* end global */


/* basic */

#holder {
	background: url(../images2/bg_holder.jpg) 50% 0 no-repeat;
	width: 100%;
	min-height: 939px;
	_height: 939px;
}

.classic #holder {
	background: url(../images2/bg_holder_gray.jpg) 50% 0 no-repeat;
}

#wrap {
	width: 985px;
	margin: 0 auto;
	padding-bottom: 25px;
	
}

#content {
	clear: both;
}

/* end basic */


/* header */

#header {
	height: 131px;
}

.topHeader {
	background: #e3e9df;
	border: 3px;
	border-right: 4px solid #f1f1f1;
	border-top: 4px solid #f1f1f1;
	padding: 3px 8px;
	text-align: center;
	color: #272727;
	font-weight: bold;
	height: 38px;
	overflow: hidden;
	float: left;
	width: 100%;
}

.headerDate {
	float: left;
	color: #fff;
	padding-top: 8px;
}

.accountLinks {
	float: right;
	text-align: right;
	font-weight: bold;
	padding-top: 8px;
}

.topHeader .separator {
	color: #929292;
	padding: 0 15px;
}

.topHeader a, .topHeader .welcomeNote {
	color: #fff;
}

.topHeader * {
	vertical-align: middle;
}

.subscribe, .subscribe div {
	display: inline;
}

.subscribe div {
	padding-left: 10px;
}

.subcribeText {
	height: 19px;
	width: 123px;
	background: url(../images2/bg_subscribe.gif) 0 0 no-repeat;
	border: none;
	color: #414141;
	font-size: 12px;
	padding: 1px 8px 0 8px;
	line-height: 12px;
}

.middleHeader {
	height: 56px;
	float: left;
	width: 100%;
}

.logo {
	margin-top: 9px;
	margin-right: 42px;
	float: left;
}

/* menu */

.navigation {
	height: 56px;
	width: 704px;
	float: left;
	background: url(../images2/main_nav_sep.gif) no-repeat 0 0;
}

#nav {
	position: relative;
}

#nav, #nav ul {
	padding: 0;
	margin: 0;
	list-style: none;
	z-index: 100;
}

#nav a {
	display: block;
	/*width: 10em;*/
	color: #fff;
	padding: 15px 47px 0 26px;
	background: url(../images2/main_nav_arrow.gif) 100% 21px no-repeat;
	font-size: 17px;
	font-family: 'Lucida Sans Unicode', 'Lucida Grande', sans-serif;
	line-height: 18px;
	height: 41px;
}


#nav li {
	float: left;
	height: 56px;
	background: url(../images2/main_nav_sep.gif) no-repeat 100% 0;
}

#nav li.last a {
	padding-right: 0;
}

/* second level */
#nav li ul.parent {
	position: absolute;
	left: -999em;
	width: 980px;
}


#nav li a {
	float: left;
}

#nav li:hover ul, #nav li.sfhover ul {
	left: -145px;
	_left: -847px;
	top: 0;
	margin-top: 56px;
}

#nav li:hover, #nav li.sfhover {
	background: url(../images2/main_nav_li_hover.gif) repeat-x 0 0 #E5E5E5;
}

#nav li:hover li, #nav li.sfhover li {
	padding-bottom: 18px;
	background: url(../images2/bg_sub_nav_b.png) no-repeat 0 100%;
	_background: none;
	height: auto;
}

#nav li:hover a, #nav li.sfhover a {
	color: #C85E01;
	text-decoration: none;
	background: url(../images2/main_nav_arrow_over.gif) no-repeat 100% 21px;
}

.subNav {
	background: url(../images2/bg_sub_nav.png) repeat-y 0 0;
	width: 920px;
	padding: 15px 30px 30px 30px;
	height: auto;
	float: left;
}

#nav li.sfhover .subNav ul, #nav li:hover .subNav ul {
	position: relative;
	top: 0;
	left: 0;
	width: 175px;
	margin: 0;
	padding: 0;
	list-style: none;
	float: left;
}

#nav li.sfhover .subNav ul.first, #nav li:hover .subNav ul.first {
	padding-left: 17px;
}

#nav li.sfhover .subNav ul li, #nav li:hover .subNav ul li {
	display: block;
	float: none;
	padding: 0;
	background: none;
	height: auto;
	line-height: 28px;
}

#nav li.sfhover .subNav ul li a, #nav li:hover .subNav ul li a {
	float: none;
	padding: 0;
	background: none;
	font-size: 12px;
	font-weight: bold;
	color: #005689;
	display: inline;
	font-family: Arial, Helvetica, sans-serif;
}

#nav li.sfhover .subNav .subNavHead a, #nav li:hover .subNav .subNavHead a {
	color: #005689;
	font-weight: bold;
	float: none;
	background: none;
	display: inline;
	font-size: 12px;
	font-family: Arial, Helvetica, sans-serif;
	position: relative;
}

#nav li.sfhover .subNav a:hover, #nav li:hover .subNav a:hover {
	text-decoration: underline;
}

.subNavHead {
	height: 25px;
	width: 100%;
	padding-top: 7px;
}

.subNavHeadClear {
	clear: both;
	border-top: 10px solid #e5e5e5;
}

.block162 {
	width: 162px;
}

.block214 {
	width: 214px;
	margin-right: 21px;
}

.block214right {
	margin-right: 0;
	float: right;
}

.block731 {
	width: 731px;
}

.block920 {
	width: 920px;
}

.block731 .subNavHead {
	background: url(../images2/sub_nav731.gif) no-repeat 0 0;
}

.block162 .subNavHead {
	background: url(../images2/sub_nav162.gif) no-repeat 0 0;
}

.block214 .subNavHead {
	background: url(../images2/sub_nav214.gif) no-repeat 0 0;
}

.block920 .subNavHead {
	background: url(../images2/sub_nav920.gif) no-repeat 0 0;
}

#nav li.sfhover .subNav .block214 ul, #nav li:hover .subNav .block214 ul {
	padding-left: 17px;
}

#nav li.sfhover .subNav .block162 ul, #nav li:hover .subNav .block162 ul {
	width: 160px;
	padding-left: 17px;
}

#nav li.sfhover .subNav .block920 ul, #nav li:hover .subNav .block920 ul {
	width: 213px;
	padding-left: 17px;
}

.subNavHead h4 {
	font-size: 20px;
	color: #005689;
	display: inline;
	padding-left: 17px;
}

.subInfo {
	background: #f4f4f4;
	padding: 9px;
	clear: both;
}

.subInfotext {
	color: #414141;
	padding-bottom: 2px;
	font-size: 11px;
}

#nav li.sfhover .subNav a.subInfoLink, #nav li:hover .subNav a.subInfoLink {
	float: none;
	display: inline;
	font-size: 14px;
	font-weight: bold;
	background: none;
	padding: 0;
	color: #005689;
	font-family: Arial, Helvetica, sans-serif;
}

/* /second level */

/* /menu */

.bottomHeader {
	height: 37px;
}

.bottomHeaderNav {
	float: left;
	padding-top: 8px;
}

.search {
	float: right;
	padding-top: 7px;
}

.searchtext {
	height: 19px;
	width: 155px;
	background: url(../images2/search_text.gif) no-repeat 0 0;
	border: none;
	padding: 2px 10px 0 22px;
}

.bottomHeaderNav a {
	color: #FFFFFF;
	font-size: 12px;
	font-family: 'Lucida Sans Unicode', 'Lucida Grande', sans-serif;
	padding-right: 40px;
}

.bottomHeaderNav a.last {
	padding-right: 0;
}	

.donate {
	float: right;
	padding-top: 12px;
}	

/* end header */

/* slider */

.slider {
	width: 985px;
	height: 391px;
	position: relative;
	background: url(../images2/slider.jpg) 0 0 no-repeat;
	margin-top: 31px;
}
/* Firefox */
@-moz-document url-prefix() 
{
.slider { margin-left: -1px; }
.topBar { margin-left: -1px; }
.topBar .boxCorner { left: -15px; }
}
/* /Firefox */

#sliderTop {
	position: absolute;
	left: 0;
	top: -15px;
}

#sliderLeft {
	position: absolute;
	left: -28px;
	top: -15px;
}

#sliderRight {
	position: absolute;
	right: -9px;
	top: -15px;
}

#container {
	padding-top: 18px;
}	

.featureLeft {
	width: 642px;
	float: left;
	padding-left: 7px;
}

.featureText {
	width: 225px;
	float: left;
	color: #fff;
	line-height: 15px;
}

.featureImg {
	float: right;
}

.featureCategory {
	color: #fff;
	font-size: 12px;
	text-transform: uppercase;
	padding-bottom: 5px;
}

.featureText h2 {
	font-size: 24px;
	line-height: 26px;
	font-weight: bold;
	color: #fff;
	padding-bottom: 10px;
}

.featureText p {
	padding-bottom: 16px;
}

a.featureMore {
	color: #fff;
	font-weight: bold;
}

.num_nav {
	float: left;
	width: 309px;
	padding-top: 18px;
}

.num_nav ul {
	list-style: none;
}

.num_nav ul li {
	float: left;
}

.num_nav ul li a span {
	float: left;
	font-size: 13px;
	font-weight: bold;
	color: #fff;
}

.num_nav ul li a {
	display: block;
	float: left;
	width: 297px;
	padding: 6px;
}

.num_nav ul li a.active {
	background-color: rgba(255,255,255,0.15);
	text-decoration: none;
}

.num_nav ul li a:hover {
	text-decoration: none;
}

.num_nav ul li img {
	float: left;
}

.num_nav ul li span {
	float: right;
	width: 190px;
	padding-left: 10px;
}

#container, #container2, #container3 { position: relative; width: 642px; height: 281px; overflow: auto; z-index: 0; float: left;}

/* /slider */


/* content */

/* columns */
.oneColumnHome {
	width: 985px;
}

.contentBlock {
	padding-bottom: 15px;
	width: 100%;
}

.twoColumnsRight {
	width: 985px;
	color: #272727;
}

.twoColumnsRight .colMain {
	width: 654px;
	float: left;
}

.twoColumnsRight .colRight {
	width: 300px;
	float:right;
	padding-right: 15px;
	overflow: hidden;
}

/* /columns */

.onNow {
	clear: both;
	width: 950px;
	height: 59px;
	float: left;
	padding: 14px 0 36px 17px;
}

.onNowTitle {
	font-size: 14px;
	color: #27930f;
	font-weight: bold;
	float: left;
	padding: 20px 20px 0 19px;
}	

.onRadio {
	float: left;
	padding-top: 13px;
	padding-right: 60px;
}

.radioOn {
	float: left;
	padding-right: 12px;
}

.onRadio span {
	font-size: 10px;
	color: #494949;
	line-height: 11px;
	display: block;
	padding-top: 2px;
}

.onRadio a {
	color: #005689;
	font-weight: bold;
	font-size: 12px;
	display: block;
}

.viewSchedule {
	float: right;
	margin: 12px 17px 0 0;
}

.shadowBox644 {
	width: 644px;
	background: url(../images2/bg_shadow_box644.gif) repeat-y 0 0;
	float: left;
}

.shadowBox655 {
	width: 660px;
	background: url(../images2/bg_shadow_box655.gif) repeat-y 0 0;
	float: left;
}

.shadowBox347 {
	float: left;
	width: 347px;
	background: url(../images2/bg_shadow_box347.gif) repeat-y 0 0;
}

.shadowBox347 .conBox {
	padding: 0 0 20px 32px;
	padding-right: 6px;
	background: url(../images2/bg_shadow_box347_bot.gif) no-repeat 16px 100%;
}

.popular {
	border-bottom: 1px solid #dbdbdb;
	padding: 18px 0;
	margin-right: 10px;
}

.popularLast {
	padding: 18px 0;
}

.shadowBox655NoBg {
	width: 660px;
	float: left;
}

.shadowBox644NoBg {
	width: 644px;
	float: left;
}

.shadowBox644NoBg .conBox {
	padding: 0 0 0 18px;
	color: #4d4e4e;
}

.shadowBox655NoBg .conBox {
	padding: 0 0 0 18px;
	color: #4d4e4e;
}

.shadowBox973 {
	width: 973px;
	background: url(../images2/bg_shadow_box973.gif) repeat-y -1px 0;
	_background: url(../images2/bg_shadow_box973.gif) repeat-y 0 0;
	float: left;
}

.shadowBox973 .conBox {
	background: url(../images2/bg_shadow_box973_bot.gif) 0 100% no-repeat;
	padding-bottom: 11px;
}

.boxHead {
	height: 32px;
	position: relative;
	margin-right: 7px;
}

.boxHead h4 {
	font-size: 14px;
	font-weight: bold;
	color: #fff;
	float: left;
	padding: 1px 10px 0 25px;
}

.shadowBox644NoBg .boxHead h4, .shadowBox973NoBg  .boxHead h4, .shadowBox655NoBg .boxHead h4 {
	padding: 1px 10px 0 17px;
}

.boxHead p {
	float: left;
	color: #fff;
	padding: 2px 0 0 0;
}

.boxHead p a {
	text-decoration: underline;
	color: #fff;
}

.boxHeadOrange {
	background: url(../images2/bg_orange_head.gif) repeat-x 0 0;
}

.boxHeadBlue {
	background: url(../images2/bg_blue_head.gif) repeat-x 0 0;
}

.boxHeadGreen {
	background: url(../images2/bg_green_head.gif) repeat-x 0 0;
}

.boxCorner {
	position: absolute;
	left: -15px;
}

@-moz-document url-prefix() 
{
.boxCorner { left: -16px; }
}

.rightBanner {
	float: right;
	padding-right: 17px;
}

.rightBlock {
	float: right;
	width: 300px;
	padding-bottom: 19px;
}

.smallText{
	font-size: 11px;
	line-height: 12px;
	padding-top: 5px;
}

.tabs {
	height: 28px;
	position: relative;
	top: -6px;
	left: 12px;
	float: left;
}

.tabs a {
	display: block;
	height: 28px;
	padding-top: 6px;
	float: left;
	width: 110px;
}

.tabs a span {
	height: 20px;
	border-right: 1px solid #fff;
	display: block;
	text-align: center;
	font-size: 14px;
	font-weight: bold;
	color: #fff;
	padding-top: 2px;
}

.tabs a:hover {
	text-decoration: none;
}

.tabs a.active {
	background: url(../images2/tabActive.gif) 0 0 no-repeat;
	text-decoration: none;
}

.tabsExpanded a {
	width: 140px;
}

.tabsExpandedSchedule a {
	width: 155px;
}

.tabsExpanded a.active {
	background: url(../images2/tabActiveExpanded.gif) 0 0 no-repeat;
}

.boxHeadGreen .tabsExpandedSchedule a.active {
	background: url(../images2/tabActiveExpandedGreen.gif) 0 0 no-repeat;
}

.boxHeadGreen .tabs {
	left: 13px;
}


.tabs a.active span {
	border: none;
	color: #b75800;
}

.boxHeadGreen .tabs a.active span {
	border: none;
	color: #255e0b;
}

.supported {
	float: right;
	color: #fff;
	padding-right: 9px;
	padding-top: 1px;
}

.supported a {
	color: #fff;
	text-decoration: underline;
}

.supportedImage {
	width: 115px;
	height: 38px;
	position: relative;
}

.supportedImageFollow {
	position: relative;
	float: left;
	top: -7px;
}

.supportedImageFollow  img {
	padding-right: 5px;
}

.supported span {
	font-size: 12px;
	float: left;
	padding-right: 10px;
}

.supportedImage {
	position: relative;
	float: left;
	width: 115px;
	height: 38px;
	top: -9px;
}

#supportBevel,  #supportBevel1 {
	position: absolute;
	top: 0;
	left: 0;
}

.logoSupport {
	position: absolute;
	left: 1px;
	top: 1px;
}
.pager {
	padding: 2px 0 6px;
	border-bottom: #e5e5e5 1px solid;
	text-align: center;
	position: relative;
	left: 15px;
	margin-right: 8px;
	margin-bottom: 10px;
	_margin-bottom: 0;
	width: 623px;
	float: left;
}
.pager img {
	vertical-align: middle;
	padding: 0 2px;
}

.featuredCon {
	padding: 11px 25px 25px 42px;
	background: url(../images2/bg_featured_bottom.jpg) 0 100% no-repeat;
	display: none;
}

.featHolderRelated .featuredCon {
	background: none;
	padding: 11px 0 0 45px;
}

.featHolderRelated .pager {
	padding: 20px 0;
	margin: 0;
	left: 0;
	width: 638px;
	margin-bottom: 15px;
}

.shadowBox655 .featuredCon {
	padding: 11px 25px 25px 42px;
	background: url(../images2/bg_featured_bottom_1.gif) 0 100% no-repeat;
	display: none;
}

.mainFeature  .featuredCon {
	padding: 11px 25px 25px 30px;
}

.featuredConVisible {
	display: block;
}


.featureLogged {
	display: none;
}

#feature01, #feature11, #feature21 {
	display: block;
}

.featHolder {
	display: none;
}

.mainFeature {
	background: url(../images2/bg_featured_top_1.gif) 0 0 no-repeat;
}

.mainFeature .pager {
	border: none;
	padding-top: 14px;
}

.mainFeatureImg {
	float: left;
}

.mainFeatureText {
	float: right;
	width: 275px;
	line-height: 16px;
}

.mainFeatureText .newTitleBig {
	font-size: 20px;
	color: #242424;
	padding-bottom: 15px;
	line-height: 24px;
}

#feat0 {
	display: block;
}

.feature {
	float: left;
	width: 130px;
	padding-right: 70px;
}

.episodes .feature {
	width: 150px;
	padding-right: 50px;
	padding-bottom: 30px;
}

.episodes .featureLast {
	padding-right: 0;
}

.featureWelcome {
	width: 170px;
	padding-right: 30px;
}

.featureWelcome ul {
	margin: 0;
	list-style: none;
}

.featureWelcome ul li {
	border-bottom: 1px solid #e5e5e5;
	font-size: 14px;
	font-weight: bold;
	padding-top: 2px;
}

.welcomeNotRegistered {
	width: 200px;
	float: left;
	padding-right: 90px;
}

.registerForm {
	width: 260px;
	float: left;
}

.welcomeNotRegistered h5, .registerForm h5 {
	color: #10627e;
	font-size: 14px;
	padding-bottom: 18px;
}

.registerForm label {
	float: left;
	clear: both;
	width: 70px;
	font-size: 11px;
	font-weight: normal;
}

.registerText {
	border: none;
	height: 17px;
	background: url(../images2/bg_register_text.gif) 0 0 no-repeat;
	width: 173px;
	margin-bottom: 3px;
}

.registerZip {
	width: 83px;
	background: url(../images2/bg_register_zip.gif) no-repeat 0 0;
}

.registerButton {
	clear: both;
	display: block;
	margin-top: 5px;
}

.feature h4 {
	font-weight: bold;
	color: #4d4e4e;
	font-size: 12px;
}
.feature h4 a {
	color: #4d4e4e;
}

.feature h4 a:hover, .feature.active h4 a {
	color: #005689;
}	

.feature h4.big {
	font-size: 14px;
	padding-bottom: 10px;
}

.feature a {
	color: #005689;
}

a.comments {
	font-size: 11px;
	background: url(../images2/bg_comment.gif) 0 2px no-repeat;
	padding-left: 20px;
	line-height: 26px;
	color: #005689;
}

a.watch {
	font-size: 11px;
	background: url(../images2/bg_watch.gif) 0 2px no-repeat;
	padding-left: 20px;
	color: #005689;
	line-height: 20px;
}

a.schedulesLink {
	font-size: 11px;
	background: url(../images2/bg_schedule.gif) 0 2px no-repeat;
	padding-left: 20px;
	color: #005689;
	line-height: 20px;
}

a.photos {
	font-size: 11px;
	background: url(../images2/bg_photos.gif) 0 2px no-repeat;
	padding-left: 20px;
	color: #005689;
	line-height: 20px;
}

a.blog {
	font-size: 11px;
	background: url(../images2/bg_blog.gif) 0 2px no-repeat;
	padding-left: 20px;
	color: #005689;
	line-height: 20px;
}

a.listen {
	font-size: 11px;
	background: url(../images2/bg_listen.gif) 0 2px no-repeat;
	padding-left: 20px;
	color: #005689;
	line-height: 20px;
}

.featuredCon .featureCategory {
	color: #005689;
	font-weight: normal;
	padding-bottom: 1px;
}

.featureLast {
	padding-right: 0;
	width: 150px;
}

.mainNew {
	padding-left: 26px;
	float: left;
	width: 260px;
}

.mainNew h4 {
	font-size: 18px;
	line-height: 22px;
	color: #414141;
}

.newCategory {
	color: #005689;
	font-size: 12px;
	text-transform: uppercase;
	padding-bottom: 2px;
	font-weight: normal;
}

.conBox {
	clear: both;
}

.new325 {
	width: 325px;
	float: left;
	padding-left: 40px;
}

.new285px {
	width: 285px;
	float: right;
	padding-right: 20px;
}

.newTitle {
	font-size: 14px;
	color: #414141;
}

.newTitleBig {
	font-size: 18px;
	color: #414141;
}

.noPadding {
	padding: 0;
}	

.newborder {
	border-bottom: 1px solid #d0d0d0;
	padding-bottom: 21px;
	margin-bottom: 20px;
}

.newborder1 {
	border-bottom: 1px solid #d0d0d0;
	padding-bottom: 8px;
	margin-bottom: 8px;
}

.new285px .newborder {
	margin-left: 10px;
	padding-bottom: 14px;
	margin-bottom: 12px;
}

.weather {
	margin-top: -10px;
}

.highlightedNews {
	padding: 10px;
	background: #d6e5ea;
}

.highlightedNews .newCategory {
	color: #414141;
}

.highlightedNews p {
	padding-bottom: 0;
}

.block290 {
	width: 290px;
	float: left;
	padding-right: 30px;
}

.icon {
	float: left;
	margin-right: 8px;
}

.iconRight {
	float: right;
	width: 246px;
}

.newborder1 .subcribeText, .subscribe1 .subcribeText {
	float: left;
	margin: 0;
	width: 185px;
	background: url(../images2/bg_subscribe1.gif) no-repeat 0 0;
	height: 23px;
}

.newborder1 .subcribeButton {
	float: right;
}

.comment {
	padding: 0 36px 0 45px;
	_margin-top: 10px;
	position: relative;
	clear: both;
	float: left;
	width: 210px;
}

.quoteStart {
	position: absolute;
	left: 20px;
	top: 0;
}

.quoteEnd {
	position: absolute;
	right: 10px;
	bottom: 0;
}

.newCategoryGray {
	color: #414141;
}

.date {
	padding: 5px 0 8px 0;
	display:  block;
}

.becomeSponsor {
	width: 316px;
	height: 297px;
	float: right;
	background: url(../images2/bg_sponsor.jpg) 0 0 no-repeat;
	position: relative;
	right: 17px;
	text-align: center;
	padding-top: 7px;
}	

.becomeSponsor img {
	border: 1px solid #dbdbdb;
}

.becomeSponsor a {
	color: #414141;
}

.shadowBox973NoBg .conBox {
	padding: 0 0 15px 17px;
}	

.newsBlock {
	padding-bottom: 20px;
	float: left;
	width: 100%;
}

.recomended .newTitleBig {
	font-size: 19px;
	padding-bottom: 10px;
}

.block300 {
	width: 300px;
	float: left;
	padding-right: 27px;
}

.recText {
	float: right;
	width: 160px;
}

.pageHead {
	height: 86px;
}

.classic .pageHead {
	height: 149px;
}

.pageTitleImg {
	padding-top: 18px;
}

.classic .pageTitleImg {
	padding-top: 25px;
	float: left;
}

.pageTitle {
	color: #fff;
	font-size: 36px;
	line-height: 40px;
	font-weight: normal;
	padding-top: 25px;
}

.topBar {
	height: 34px;
	background: url(../images2/bg_top_bar.jpg) no-repeat -5px 0;
	margin-bottom: 25px;
	position: relative;
}

.classic .topBar {
	background: url(../images2/bg_top_bar_gray.jpg) no-repeat -5px 0;
}

.topBar .left {
	padding: 6px 0 0 0;
	color: #fff;
}

.topBar .left a {
	color: #fff;
}

.topBarCategory {
	float: left;
	font-size: 12px;
	color: #fff;
	font-weight: bold;
	text-transform: uppercase;
	padding-right: 13px;
	border-right: 2px solid #05516f;
	margin-right: 10px;
	padding-left: 1px;
}

.topBarCategoryNoB {
	border: none;
}

.topBarCategory img {
	padding: 0 5px;
}

.topBar .left span {
	font-size: 11px;
	color: #fff;
}

.topBar .left span * {
	vertical-align: middle;
}

.topBar .right {
	padding: 6px 17px 0 0;
}

.topBar .right * {
	vertical-align: middle;
}

.share {
	float: left;
	padding-right: 13px;
	border-right: 2px solid #05516f;
	margin-right: 10px;
	color: #fff;
	font-weight: bold;
	font-size: 14px
}

.classic .share {
	border-right: 2px solid #605843;
}

.pHeaderClassic .share {
	border-right: 2px solid #4f4f4f;
}

.share a {
	color: #fff;
	font-size: 10px;
}

.like {
	float: left;
	font-weight: bold;
	font-size: 14px;
	color: #fff;
}

.like img {
	cursor: pointer;
}

.like a.likeButton {
	padding-left: 5px;
}

.featurePopup {
	width: 394px;
	background: url(../images2/popupTop.png) no-repeat 0 0;
	position: absolute;
	top: -50%;
	left: 140px;
	padding-top: 7px;
	display: none;
}

.featurePopupIn {
	padding: 0 12px 0 6px;
	background: url(../images2/popupMiddle.png) 0 0 repeat-y;
	float: left;
	width: 377px;
}

.featurePopup h4 {
	padding: 25px 16px 5px 16px;
	font-size: 18px;
	color: #272727;
	border-bottom: 1px solid #e5e5e5;
}

.popupInfo {
	padding: 5px 16px 10px 16px;
	border-bottom: 1px solid #e5e5e5;
}

.rightBlock .popupInfo {
	padding: 0;
	border: none;
}

.popupInfo h5 {
	font-size: 14px;
	color: #272727;
}

.popupInfo1 {
	color: #9a9a9a;
	padding: 0;
}	

.popupAvailable {
	padding: 1px 0 0 0;
}

.rightBlock .popupAvailable {
	padding: 1px 0 5px 0;
}

.popupAvailable * {
	vertical-align: middle;
}

.popupInfo1 strong {
	color: #272727;
}

.popuptext {
	padding: 5px 16px 10px 16px;
}

.popupBottom {
	width: 100%;
	background: url(../images2/popupBottom.png) 0 100% no-repeat;
	height: 20px;
	float: left;
}

.featureActive {
	position: relative;
}

.featureActive .featurePopup {
	display: block;
}

.schedule table {
	border: 4px solid;
	border-collapse: separate;
	background: #f1f1f1;
	position: relative;
	top: 10px;
	width: 640px;
}

.schedule table td {
	background: #e3e9df;
	border: 3px;
	border-right: 4px solid #f1f1f1;
	border-top: 4px solid #f1f1f1;
	padding: 3px 8px;
	text-align: left;
	color: #272727;
	font-weight: bold;
}

.schedule table th {
	border: 3px solid;
	background: #c9dbbc;
	border-right: 4px solid #f1f1f1;
	text-align: left;
	padding: 3px 8px;
}

.schedule table th .day {
	font-size: 14px;
	color: #272727;
	font-weight: bold;
}

.schedule table th .time {
	font-size: 12px;
	color: #272727;
	font-weight: bold;
}

.schedule table th .show {
	font-size: 12px;
	color: #272727;
	font-weight: normal;
}

.related {
	width: 290px;
	padding-bottom: 45px;
	padding-right: 10px;
	line-height: 15px;
}

.relatedLeft {
	padding-top: 9px;
	width: 130px;
	float: left;
}

.relatedText {
	padding-top: 6px;
	float: right;
	width: 152px;
}

.relatedLeft a {
	color: #272727;
}

.onTwitter {
	width: 290px;
	float: right;
	margin-right: 10px;
}

.twitterPosts {
	background: url(../images2/bg_twitter.gif) 0 0 no-repeat #fff;
	padding: 14px 10px 0 10px;
}

.onTwitter h4 {
	padding: 9px 0 12px 47px;
	font-size: 19px;
	color: #272727;
	background: url(../images2/bg_twitter_title.jpg) 0 0 no-repeat;
}

.twPost {
	padding: 10px 0;
	border-bottom: 1px solid #eaeaea;
}

.twPostLast {
	border: none;
}

.commentText {
	width: 613px;
	padding: 10px;
	border: 1px solid #b8b8b8;
	height: 60px;
	overflow: auto;
	margin-bottom: 10px;
}

.collectedComments {
	padding-top: 18px;
}

.commentBlock {
	padding: 12px 0;
	border-bottom: 1px solid #fff;
	border-top: 1px solid #d4d4d4;
	margin-right: 10px;
}

.commentBlockFirst {
	border-top: none;
}

.commentBlockLast {
	border-bottom: none;
}

.title16 {
	font-size: 16px;
	padding-bottom: 5px;
}

.lightText {
	color: #4d4e4e;
}

.supportAdd {
	width: 280px;
	padding: 10px;
	background: url(../images2/bg_support_text.gif) no-repeat 0 0;
	float: right;
	margin-bottom: 0px;
}

.supportAdd h4 {
	font-size: 14px;
	padding-bottom: 6px;
}

.supportAdd p {
	font-size: 11px;
	padding-bottom: 5px;
}

.eventsBlock {
	width: 300px;
	float: right;
	margin-bottom: 19px;
}

.eventsBlock h3 {
	padding: 3px 10px;
	background: #30759e;
	color: #fff;
	font-size: 14px;
}

.eventsBlock h3 a {
	font-weight: normal;
	float: right;
	color: #fff;
}

.topicsBlock {
	width: 100%;
	float: right;
	margin-bottom: 19px;
}

.box300Right {
	width: 300px;
	float: right;
}

.box300Right li {
	font-size: 14px;
}

.topicsBlock h3 {
	padding: 3px 10px;
	background: #6ba743;
	color: #fff;
	font-size: 14px;
}

.moreArts {
	padding-bottom: 25px;
}

.moreArts p.smallText {
	font-size: 11px;
	padding: 0;
}

.moreArts h3 {
	padding: 3px 10px;
	background: #df8230;
	color: #fff;
	font-size: 14px;
}

.art {
	padding: 10px;
}

.artTop {
	border-bottom: 1px solid #fff;
}

.artBottom {
	border-top: 1px solid #d4d4d4;
}

.art h4 {
	font-size: 16px;
	padding-bottom: 0px;
}

.topicsBlock ul {
	list-style: none;
	padding: 10px 0;
	margin-left: 10px;

}

.topicsBlock ul li {
	line-height: 20px;
}

.upercase {
	text-transform: uppercase;
}

.event {
	padding: 10px;
}

.event h4 {
	font-size: 16px;
}

.event p {
	padding-bottom: 0;
	color: #323232;
}

.seeEvents {
	float: left;
	padding: 10px;
	font-weight: bold;
}



.toprelated .related {
	padding-bottom: 18px;
	border-bottom: 1px solid #fff;
	padding-right: 0;
	margin-right: 12px;
}

.midrelated .related {
	padding-bottom: 18px;
	padding-top: 18px;
	border-top: 1px solid #d4d4d4;
	border-bottom: 1px solid #fff;
	padding-right: 0;
	margin-right: 12px;
}

.botrelated .related {
	padding-bottom: 18px;
	border-top: 1px solid #d4d4d4;
	padding-top: 18px;
	padding-right: 0;
	margin-right: 12px;
}

.toprelated .related a, .midrelated .related a, .botrelated .related a {
	color: #005689;
}

.moreArts .related .newTitleBig {
	font-size: 16px;
}	

.articleBlock {
	padding: 0 0 25px 15px;
	width: 640px;
}

.articleImg {
	color: #888888;
	width: 315px;
	float: left;
	padding: 0 20px 20px 0; 
}

.articleBlock .articleImg p {
	font-size: 12px;
	padding-bottom: 0;
}

.articleBlock p {
	font-size: 14px;
	line-height: 20px;
}

.block205 {
	width: 205px;
	float: left;
	padding-right: 40px;
}

.block318 {
	width: 310px;
}

.block318Left {
	float: left;
	padding-left: 15px;
}

.block318Right {
	float: right;
}

.byText {
	width: 300px; 
	float: right;
}

.myWgbhLink {
	color: #fff;
	float: right;
	padding-right: 13px;
}

.myWgbhBlock ul {
	list-style: none;
	margin: 0 0 15px 0;
	font-weight: bold;
}

.myWgbhBlock ul li {
	padding-bottom: 4px;
}

.myWgbhBlock ul a {
	color: #000;
}

/* end content */

/* popout media */

.pHolder {
	width: 990px;
	margin: 0 auto;
}

.pHeader {
	height: 109px;
	background: url(../images2/popout_header.jpg) no-repeat 0 0;
	overflow: hidden;
}

.pHeaderClassic {
	height: 109px;
	background: url(../images2/popout_header_gray.jpg) no-repeat 0 0;
	overflow: hidden;
}

.pPageTitle {
	float: left;
	color: #fff;
	margin: ;
	font-size: 36px;
	font-weight: normal;
	margin: 19px 0 0 16px;
}

.pLogo {
	float: right;
	margin: 19px 16px 0 0;
}

.pTopBar {
	background: none;
	clear: both;
	padding: 17px 0 0 17px;
}

.pContent {
	padding: 11px 12px 20px 11px;
}

.pContent .colLeft {
	width: 648px;
	float: left;
}

.pContent .colRight {
	width: 310px;
	float: right;
	text-align: center;
}

.pVideo {
	background: url(../images2/bg_p_video.gif) repeat-y 0 0;
	margin-bottom: 40px;
}

.player {
	float: left;
	width: 315px;
	height: 177px;
	padding: 11px 0 11px 15px;
}

.pVideoRight {
	float: right;
	width: 294px;
	padding: 11px 11px 11px 0;
}

.pVideoRight .popupInfo {
	padding: 0;
	border: none;
}

.videoRightInfo {
	text-align: left;
	margin-bottom: 10px;
}

.videoRightInfo .popupInfo {
	border: none;
	padding: 0 7px;
}

.videoText {
	padding: 0 7px;
}

.actions {
	height: 31px;
	background: url(../images2/bg_actions.gif) repeat-x 0 0;
	margin: 0 4px 0 5px;
	width: 639px;
	float: left;
	padding-left: 1px;
}

.actions * {
	vertical-align: middle;
}

.actions a {
	color: #fff;
	float: left;
	height: 26px;
	padding: 5px 13px 0 13px;
}

.actions a:hover {
	text-decoration: none;
}

.actions img {
	margin-right: 2px;
}

.psupportAdd {
	float: left;
}

.pConRight {
	width: 300px;
	float: right;
}

.pConRight ul {
	list-style: none;
	margin: 0;
}

.pConRight ul li {
	border-bottom: 1px solid #e5e5e5;
	padding: 2px 0 2px 0;
}

.pConRight ul li h4 {
	color: #41bf25;
	font-size: 17px;
}

.pConRight ul li a {
	font-size: 14px;
	font-weight: bold;
}

.pConRight ul.ul115 {
	width: 115px;
	float: left;
}

.pConRight ul.ul166 {
	width: 166px;
	float: right;
}

.related1 {
	width: 310px;
	background: url(../images2/bg_related.gif) repeat-y 0 0;
	margin-bottom: 19px;
	padding: 0;
}

.related1 .pager {
	border: none;
	padding: 10px 0;
	background: none;
	width: 310px;
	position: relative;
	margin: 0;
	left: 0;
}

.related1 .pager h3 {
	position: absolute;
	top: 10px;
	left: 14px;
	font-size: 14px;
}

.relatedTop {
	float: left;
}

.relatedItem {
	display: none;
}

.relatedItemText {
	width: 140px;
	float: right;
	text-align: left;
	color: #272727;
	padding-right: 14px;
	margin-bottom: 10px;
}

.relatedImage {
	float: left;
	margin-left: 15px;
	margin-bottom: 10px;
}

.relatedItemText h4 {
	font-size: 12px;
}

.relatedItemText  p {
	padding-bottom: 0;
}

.videoImg {
	float: left;
}

.videoHolder {
	width: 640px;
	margin-bottom: 19px;
	left: 14px;
	float: left;
	height: 390px;
	position: relative;
}

.videoHolder .actions {
	margin: 0;
}

.videoHolder1 {
	float: left;
	margin-bottom: 19px;
	position: relative;
	height: 390px;
}

.videoHolder1 .actions {
	margin: 0;
}

.ppsupportAdd {
	position: relative;
	right: 5px;
	text-align: left;
}

.relatedHolder {
	position: absolute;
	width: 638px;
	height: 359px;
	top: 0;
	left: 0;
	border: 1px solid #000;
	border-bottom: none;
	background: #fff;
	display: none;
}

.relatedHolder .feature p {
	padding: 0;
}

a.activeRelated {
	background: url(../images2/bg_active_related.gif) repeat-x 0 0;
	float: left;
	color: #b25401;
}

.relatedHead {
	height: 22px;
	background: #e18533;
}

.relatedHead h3 {
	float: left;
	font-size: 14px;
	padding: 2px 0 0 8px;
	color: #fff;
}

a.close {
	float: right;
	color: #fff;
	padding: 1px 2px 0 0;
}

a.close:hover {
	text-decoration: none;
}
.close * {
	vertical-align: middle;
}

/* /popout media */

/* classic */

.listenLive {
	float: left;
	margin-top: 68px;
	margin-left: 55px;
}

.viewPlaylist {
	float: left;
	margin-top: 68px;
	margin-left: 13px;
}

.classicalChanels {
	float: right;
	margin-top: 57px;
	width: 280px;
}

.classicalChanels h6 {
	color: #fff;
	font-size: 12px;
	font-weight: bold;
	padding-bottom: 2px;
	display: inline;
}
.classicalChanels a {
	float: right;
	background: #3d3d3d;
	margin-left: 1px;
	padding: 2px 7px;
	color: #fff;
}

.shadowBox340 {
	width: 340px;
	float: left;
}

.shadowBox340 .boxHead, .shadowBox295 .boxHead {
	margin-right: 0;
}

.shadowBox340 .boxHead h4, .shadowBox295 .boxHead h4 {
	padding-left: 17px;
}

.shadowBox295 {
	float: right;
	width: 295px;
}

.view_shedule {
	float: right;
	padding-right: 10px;
	padding-top: 1px;
	color: #fff;
}

.blockCon {
	padding: 17px;
	padding-top: 0;
}

.onNowText {
	float: right;
	width: 170px;
}

.onTime {
	padding: 0 0 2px 0;
	color: 	#005689;
}

.noteText {
	padding-bottom: 5px;
}

.moreClassical {
	padding: 0 10px; 
	margin-right: 10px;
}

.moreTop {
	padding-bottom: 15px;
	border-bottom: 1px solid #fff;
}

.moreMid {
	padding-bottom: 15px;
	padding-top: 15px;
	border-bottom: 1px solid #fff;
	border-top: 1px solid #d4d4d4;
}

.moreBot {
	padding-top: 15px;
	border-top: 1px solid #d4d4d4;
}

/* /classic */


/* schedule */

.tableHolder {
	padding: 0 0 0 26px;
}

table.sheduleHolderTable {
	width: 790px;
	color: #2e2e2e;
	border: none;
	border-collapse: collapse;
	position: relative;
}

table.shedule {
	border-collapse: collapse;
	border: none;
}

table.sheduleHolderTable th {
	font-weight: bold;
	background: #d2e4c6;
	font-size: 14px;
	height: 36px;
}

table.sheduleHolderTable .col th {
	border-right: 3px solid #fff;
	width: 109px;
	height: 37px;
}

table.shedule th {
	border-bottom: 3px solid #fff;
	width: 130px;
	height: 36px;
}

table.sheduleHolderTable th.row {
	height: 57px;
	border-bottom: 3px solid #fff;
	padding-left: 10px;
	width: 118px;
}

table.sheduleHolderTable th.row a {
	color: #2e2e2e;
}

table.sheduleHolderTable th.row1 {
	padding-left: 10px;
	text-align: left;
	width: 118px;
	border-right: 3px solid #fff;
}

table.sheduleHolderTable th.row1, table.sheduleHolderTable th.odd, table.sheduleHolderTable th.even {
	border-right: none;
	border-bottom: 3px solid #fff;
	padding-left: 10px;
}

table.sheduleHolderTable td {
	border: 3px solid #fff;
	background: #f0f6ec;
	height: 57px;
	font-weight: normal;
	font-size: 10px;
	line-height: 12px;
	padding: 0;
	width: 90px;
}

table.sheduleHolderTable div.scheduleHolder {
	height: 47px;
	width: 88px;
	padding: 5px 10px 0 10px;
	position: relative;
	left: 0!;
	top: 0;
}

table.sheduleHolderTable td.wgbhTd {
	padding: 0;
}

table.sheduleHolderTable td.wgbhTd div.scheduleHolder {
	height: 47px;
	width: 88px;
	padding: 5px 10px 0 10px;
	border: 1px solid #6ba743;
	position: relative;
	left: 0;
}

.wgbhActive {
	position: absolute;
	bottom: -1px;
	right: -1px;
	/*_bottom: -2px;
	_right: -2px;*/
}

table.sheduleHolderTable td.wgbhTd2 div.scheduleHolder {
	width: 200px;
}

table.sheduleHolderTable td a {
	
}

table.sheduleHolderTable td a.active {
	position: relative;
	display: block;
	border: 1px solid #6ba743;
}

table.sheduleHolderTable td.noborder {
	border: none;
	padding: 0;
	width: auto;
}

.dateShow {
	font-weight: normal;
}

a.arrow_left {
	display: block;
	float: right;
	position: relative;
	right: 5px;
}

.row1 span {
	float: left;
	padding-bottom: 2px;
	padding-top: 2px;
}

.videoIcon {
	margin-top: 3px;
}

#arrowRight {
	position: absolute;
	right: 145px;
	top: 9px;
}

table.sheduleHolderTable th.row1 {
	font-weight: normal;
	vertical-align: middle;
	height: 37px;
}

table.sheduleHolderTable th.row1 a {
	vertical-align: middle;
	padding: 0;
	display: inline;
	/*padding-left: 25px;*/
}

.calendarHolder {
	width: 122px;
	position: absolute;
	right: 25px;
	top: 39px;
}

.schedCalHeader {
	background: #d2e4c6;
	padding: 3px 10px 3px 0;
	text-align: center;
	border-bottom: 2px solid #fff;
	font-size: 14px;
}

.calendarArrow {
	position: absolute;
	right: 10px;
	top: 5px;
}

.calendarHolder th {
	font-size: 14px;
}

.calendarHolder td {
	text-align: center;
	color: #959595;
	font-size: 11px;
}

.dateActive {
	background: #6ba743;
}

.dateActive a {
	color: #fff;
}

.scheduleHolderActive {
	background: #d2e4c6;
	position: relative;
	
}

.scheduleHolderActive .featurePopup {
	display: block;
	z-index: 100;
	left: 100px;
}

.scheduleHolder {
	z-index: 0;
}

.scheduleHolderActive {
	z-index: 1;
}

.schedulesMainHolder {
	display: none;
}

/* /schedule */

/* footer */

#footer {
	background: url(../images2/bg_footer.jpg) 50% 0 no-repeat;
	height: 260px;
}	

.classic #footer {
	background: url(../images2/bg_footer_gray.jpg) 50% 0 no-repeat;
}

.footerIn {
	width: 985px;
	margin: 0 auto;
	padding-top: 28px;
	height: 180px;
	font-size: 12px;
	line-height: 18px;
	color: #414141;
}

.footerSupport {
	float: right;
	font-size: 10px;
	text-align: center;
	padding: 12px;
	background: url(../images2/bg_sponsors.jpg) no-repeat 0 0;
}

.classic .footerSupport {
	background: url(../images2/bg_sponsors_gray.gif) no-repeat 0 0;
}

.footerIn a {
	color: #414141;
}

.footerSupport p {
	padding: 0;
	clear: both;
}

.sponsorBanner {
	font-size: 0;
	display: block;
	float: left; 
}

.sponsorBanner img {
	float: left;
}

.footerLinks {
	float: left;
}

.fLinksBlock {
	float: left;
	padding-right: 70px;
	font-size: 12px;
}

.fLinksBlockLast {
	padding-right: 0;
}

.fLinksBlock h4 {
	color: #373737;
	font-weight: bold;
	font-size: 18px;
	padding-bottom: 4px;
	
}

.fLinksBlock ul {
	margin: 0;
	list-style: none;
	
}
 
.fLinksBlock ul li {
	line-height: 22px;
}

.copyRightHolder {
	padding-top: 30px;
	clear: both;
	width: 724px;
}

.copyRightHolder .left {
	padding: 0;
}

.copyRightHolder .left a {
	padding-right: 8px;
}

.copyRightHolder .right {
	padding-top: 3px;
}

.copyRightHolder .right .separator {
	padding: 0 17px;
}

.fLinksBlock ul li.purchaseNote {
	font-size: 11px;
	padding-top: 10px;
	line-height: 16px;
}
	
/* end footer */

/* added by Barry */



.clearfix:after {
    content: ".";
    display: block;
    height: 0;
    line-height: 0;
    clear: both;
    visibility: hidden;
}

.clearfix {display: inline-block;}

/* Hides from IE-mac \*/
* html .clearfix {height: 1%;}
.clearfix {display: block;}
/* End hide from IE-mac */



.boxCornerWide {
	position: absolute;
	left: -30px;
}

@-moz-document url-prefix()
{
.boxCornerWide { left: -31px; }
}

/* for fck/ck editor */
/* Big Text Paragraph */
p.big {
    font-size: 18px;
	line-height: 26px;
}
div.big {
    font-size: 18px;
	line-height: 26px;
}
.big {
    font-size: 18px;
	line-height: 26px;
}

/* Big Text Span */
span.big {
	font-size: 18px;
	line-height: 26px;
}

/* Big Bold Text */
strong.big {
	font-size: 18px;
	font-weight: bold;
	line-height: 26px;
}

b.big {
    font-size: 18px;
	font-weight: bold;
	line-height: 26px;
}

/* Very Big Span */
.veryBig {
	font-size: 20px;
	font-weight: normal;
	line-height: 32px;
}

/* H2 Subheader */
h2.subhead {
	font-size: 20px;
	color: #1c4872;
	line-height: 26px;
	font-weight: normal;
	padding-top: 10px;
	padding-bottom: 15px;
}

/* H2 No Padding */
h2.noPad {
	font-size: 16px;
	font-weight: normal;
	padding: 0;
	margin: 0;
	line-height: 20px;
}

/* H3 Subheader */
h3.subhead {
	font-size: 16px;
	color: #5a5a5a;
	line-height: 22px;
	padding: 0 0 10px 0;
}

/* H4 Subheader */
h4.subhead {
    font-size: 12px;
	color: #1c4872;
	line-height: 18px;
	padding: 0 0 2px 0;
}

/* Left Column Header */  /* ****** create new - wont look right */
h2.h2LeftCol {

}

/* Left Column */  /* ****** create new - wont look right */
div.genericLeftCol {

}

/* Adlob Header */
.adlobHeader {
    margin:0 0 8px 0;
    padding:0;
	color: #666;
    font-size:14px;
    font-weight:bold;
}

/* Quote */
.quote {
	color: #1c4872;
    font-size:22px;
    font-style: italic;
    font-family: Times New Roman;
    line-height:24px;
}

/* Quote Attribution */
.quoteAttribution {
	color: #1c4872;
    font-size:12px;
    line-height:24px;
}

/* Photo Credit */
.photoCredit {
	color: #f57420;
    font-size:11px;
    font-style: italic;
}

/* Caption */
.captions {
	color: #125687;
	font-weight: bold;
    font-size:12px;
}

h3.headerbarGreen {
	padding: 3px 10px;
	background: #6ba743;
	color: #fff;
	font-size: 14px;
    margin-bottom:8px;
}

h3.headerbarOrange {
	padding: 3px 10px;
	background: #df8230;
	color: #fff;
	font-size: 14px;
    margin-bottom:8px;
}

h3.headerbarBlue {
	padding: 3px 10px;
	background: #30759E;
	color: #fff;
	font-size: 14px;
    margin-bottom:8px;
}

/* /end for fck/ck editor */


a.iconLink {
	font-size: 11px;
	line-height: 26px;
	color: #005689;
}

.coloredSideBlock {
	width: 100%;
	float: right;
	margin-bottom: 19px;
}

.coloredSideBlock h3 {
	padding: 3px 10px;
	background: #6ba743;
	color: #fff;
	font-size: 14px;
}

.coloredSideBlock ul {
	list-style: none;
	padding: 10px 0;
	margin-left: 10px;

}

.coloredSideBlock ul li {
	line-height: 20px;
}

/* begin BRW */

.positionDetailSurround
{
	border: 1px solid #478094;
	padding: 5px 5px;
}

table.positionInformation
{
	padding: 5px 5px;
	border: 1px solid #478094;
	width: 800px;
}
.positionInformationHeader
{
	font-size: 11px;
	font-weight: bold;
	white-space: nowrap;
	border-bottom: 1px solid #478094;
	padding: 5px 5px;
}

.positionInformationText
{
	/*font-size: 11px; - Commented by Ketan Benegal*/
	font-size: 12px;
	white-space: nowrap;
	padding: 5px 5px;
}

.positionInformationNoWrap
{
	/*font-size: 11px; - Commented by Ketan Benegal*/
	font-size: 12px;
	padding: 5px 5px;
	word-wrap: break-word;
}

/* begin application wizard */

.applicationDetailSurround
{
	width: 800px;
	border: 1px solid #478094;
	padding: 5px 5px;
}

.generalTextHeader
{
	font-size: 12;
	padding: 5px 5px;
	text-align: left;
	font-weight: bold;
}

table.applicationInformation
{
	padding: 5px 5px;
	border: 1px solid #478094;
	width: 600px;
}

td.applicationInformationText
{
	padding: 5px 5px;
	text-align: right;
}

tr.applicationInformationQuestionRow
{
	white-space: nowrap;
	border-bottom: 1px solid #478094;
}

td.applicationInformationTextBold
{
	font-weight: bold;
	padding: 5px 5px;
	text-align: left;
}

.applicationInformationLabelRequired
{
	font-size: 11px;
	color: red;
	word-wrap: break-word;
	padding: 5px 5px;
}

.applicationInformationLabelPlain
{
	font-size: 11px;
	word-wrap: break-word;
	padding: 5px 5px;
}

.resumeCoverLetterSection
{
	padding: 5px 5px;
	border: 1px solid #478094;
	width: 787px;
}

.applicationInformationNoWrap
{
	font-size: 11px;
	padding: 5px 5px;
	word-wrap: break-word;
}

.resumeInformationNoWrap
{
	/*font-size: 11px; -- Ketan Benegal*/
	font-size: 13px;
	padding: 5px 5px;
	border: 1px solid #478094;
	width: 800px;
	word-wrap: break-word;
	position: relative;
	text-align: left;
}

table.employmentInformation
{
	padding: 5px 5px;
	border: 1px solid #478094;
	width: 800px;
}

td.employmentInformationTextBold
{
	padding: 5px 5px;
	text-align: left;
	font-weight: bold;
}

td.employmentInformationText
{
	padding: 5px 5px;
	text-align: left;
}
  /* end added by Barry */