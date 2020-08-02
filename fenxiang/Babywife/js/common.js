
var httpUrl = 'http://118.89.36.69:2019';  //域名

//弹框通用
function alert(text){
	$(".alert").css('display','block');
	$(".alert").text(text);
	setTimeout(function(){
		$(".alert").css('display','none');
	},2000)
}

//从连链接取上一页传过来的参数
function getQueryString(name,noUnescape){
	var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)","i");
	var r = window.location.search.substr(1).match(reg); //window.location控制获取当前页面的url参数
	console.log(window.location.search);
	console.log(r);
	noUnescape = noUnescape == undefined ? false : noUnescape;
	if(noUnescape){
		if(r != null) return r[2]; return null;
	}else{
		if(r != null) return decodeURI(r[2]); return null;
	}
	
}