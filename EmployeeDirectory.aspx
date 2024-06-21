<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true"
    CodeFile="EmployeeDirectory.aspx.cs" Inherits="EmployeeDirectory" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
         body
        {
            font-family: 'Source Sans Pro','Helvetica Neue',Helvetica,Arial,sans-serif !important;
            font-weight: 400 !important;
        }
	.content {
	   padding-bottom: 0px !important;
	}
	
	.masthead {
		height : 0px !important;
	}
	
	.nav > li > a > i {
		margin-right : 10px !important;
	}
	
	.nav-tabs > li > a {
		padding : 10px 20px !important;
	}
	.nav-pills > li > a {
	 	padding-left : 20px !important;
	 	padding-right : 20px !important;
	}
	
	.home-dashboard-attendance2 .panel-content {
		min-height : 204px;
	}	
	
	.mobileAppAddForm .error{
		color: black;
	}
	/*!
 * Bootstrap v2.0.4
 *
 * Copyright 2012 Twitter, Inc
 * Licensed under the Apache License v2.0
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Designed and built with all the love in the world @twitter by @mdo and @fat.
 */article,aside,details,figcaption,figure,footer,header,hgroup,nav,section{display:block}audio,canvas,video{display:inline-block;*display:inline;*zoom:1}audio:not([controls]){display:none}html{font-size:100%;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%}a:focus{outline:thin dotted #333;outline:5px auto -webkit-focus-ring-color;outline-offset:-2px}a:hover,a:active{outline:0}sub,sup{position:relative;font-size:75%;line-height:0;vertical-align:baseline}sup{top:-0.5em}sub{bottom:-0.25em}img{max-width:100%;vertical-align:middle;border:0;-ms-interpolation-mode:bicubic}#map_canvas img{max-width:none}button,input,select,textarea{margin:0;font-size:100%;vertical-align:middle}button,input{*overflow:visible;line-height:normal}button::-moz-focus-inner,input::-moz-focus-inner{padding:0;border:0}button,input[type="button"],input[type="reset"],input[type="submit"]{cursor:pointer;-webkit-appearance:button}input[type="search"]{-webkit-box-sizing:content-box;-moz-box-sizing:content-box;box-sizing:content-box;-webkit-appearance:textfield}input[type="search"]::-webkit-search-decoration,input[type="search"]::-webkit-search-cancel-button{-webkit-appearance:none}textarea{overflow:auto;vertical-align:top}.clearfix{*zoom:1}.clearfix:before,.clearfix:after{display:table;content:""}.clearfix:after{clear:both}.hide-text{font:0/0 a;color:transparent;text-shadow:none;background-color:transparent;border:0}.input-block-level{display:block;width:100%;min-height:28px;-webkit-box-sizing:border-box;-moz-box-sizing:border-box;-ms-box-sizing:border-box;box-sizing:border-box}body{margin:0;font-family:"Helvetica Neue",Helvetica,Arial,sans-serif;font-size:13px;line-height:18px;color:#333;background-color:#fff}a{color:#08c;text-decoration:none}a:hover{color:#005580;text-decoration:underline}.row{margin-left:0px;*zoom:1}.row:before,.row:after{display:table;content:""}.row:after{clear:both}[class*="span"]{float:left;margin-left:20px}.container,.navbar-fixed-top .container,.navbar-fixed-bottom .container{width:940px}.span12{width:940px}.span11{width:860px}.span10{width:780px}.span9{width:700px}.span8{width:620px}.span7{width:540px}.span6{width:460px}.span5{width:380px}.span4{width:300px}.span3{width:220px}.span2{width:140px}.span1{width:60px}.offset12{margin-left:980px}.offset11{margin-left:900px}.offset10{margin-left:820px}.offset9{margin-left:740px}.offset8{margin-left:660px}.offset7{margin-left:580px}.offset6{margin-left:500px}.offset5{margin-left:420px}.offset4{margin-left:340px}.offset3{margin-left:260px}.offset2{margin-left:180px}.offset1{margin-left:100px}.row-fluid{width:100%;*zoom:1}.row-fluid:before,.row-fluid:after{display:table;content:""}.row-fluid:after{clear:both}.row-fluid [class*="span"]{display:block;float:left;width:100%;min-height:28px;margin-left:2.127659574%;*margin-left:2.0744680846382977%;-webkit-box-sizing:border-box;-moz-box-sizing:border-box;-ms-box-sizing:border-box;box-sizing:border-box}.row-fluid [class*="span"]:first-child{margin-left:0}.row-fluid .span12{width:99.99999998999999%;*width:99.94680850063828%}.row-fluid .span11{width:91.489361693%;*width:91.4361702036383%}.row-fluid .span10{width:82.97872339599999%;*width:82.92553190663828%}.row-fluid .span9{width:74.468085099%;*width:74.4148936096383%}.row-fluid .span8{width:65.95744680199999%;*width:65.90425531263828%}.row-fluid .span7{width:57.446808505%;*width:57.3936170156383%}.row-fluid .span6{width:48.93617020799999%;*width:48.88297871863829%}.row-fluid .span5{width:40.425531911%;*width:40.3723404216383%}.row-fluid .span4{width:31.914893614%;*width:31.8617021246383%}.row-fluid .span3{width:23.404255317%;*width:23.3510638276383%}.row-fluid .span2{width:14.89361702%;*width:14.8404255306383%}.row-fluid .span1{width:6.382978723%;*width:6.329787233638298%}.container{margin-right:auto;margin-left:auto;*zoom:1}.container:before,.container:after{display:table;content:""}.container:after{clear:both}.container-fluid{padding-right:20px;padding-left:20px;*zoom:1}.container-fluid:before,.container-fluid:after{display:table;content:""}.container-fluid:after{clear:both}p{margin:0 0 9px}p small{font-size:11px;color:#999}.lead{margin-bottom:18px;font-size:20px;font-weight:200;line-height:27px}h1,h2,h3,h4,h5,h6{margin:0;font-family:inherit;font-weight:bold;color:inherit;text-rendering:optimizelegibility}h1 small,h2 small,h3 small,h4 small,h5 small,h6 small{font-weight:normal;color:#999}h1{font-size:30px;line-height:36px}h1 small{font-size:18px}h2{font-size:24px;line-height:36px}h2 small{font-size:18px}h3{font-size:18px;line-height:27px}h3 small{font-size:14px}h4,h5,h6{line-height:18px}h4{font-size:14px}h4 small{font-size:12px}h5{font-size:12px}h6{font-size:11px;color:#999;text-transform:uppercase}.page-header{padding-bottom:17px;margin:18px 0;border-bottom:1px solid #eee}.page-header h1{line-height:1}ul,ol{padding:0;margin:0 0 9px 25px}ul ul,ul ol,ol ol,ol ul{margin-bottom:0}ul{list-style:disc}ol{list-style:decimal}li{line-height:18px}ul.unstyled,ol.unstyled{margin-left:0;list-style:none}dl{margin-bottom:18px}dt,dd{line-height:18px}dt{font-weight:bold;line-height:17px}dd{margin-left:9px}.dl-horizontal dt{float:left;width:120px;overflow:hidden;clear:left;text-align:right;text-overflow:ellipsis;white-space:nowrap}.dl-horizontal dd{margin-left:130px}hr{margin:18px 0;border:0;border-top:1px solid #eee;border-bottom:1px solid #fff}strong{font-weight:bold}em{font-style:italic}.muted{color:#999}abbr[title]{cursor:help;border-bottom:1px dotted #999}abbr.initialism{font-size:90%;text-transform:uppercase}blockquote{padding:0 0 0 15px;margin:0 0 18px;border-left:5px solid #eee}blockquote p{margin-bottom:0;font-size:16px;font-weight:300;line-height:22.5px}blockquote small{display:block;line-height:18px;color:#999}blockquote small:before{content:'\2014 \00A0'}blockquote.pull-right{float:right;padding-right:15px;padding-left:0;border-right:5px solid #eee;border-left:0}blockquote.pull-right p,blockquote.pull-right small{text-align:right}q:before,q:after,blockquote:before,blockquote:after{content:""}address{display:block;margin-bottom:18px;font-style:normal;line-height:18px}small{font-size:100%}cite{font-style:normal}code,pre{padding:0 3px 2px;font-family:Menlo,Monaco,Consolas,"Courier New",monospace;font-size:12px;color:#333;-webkit-border-radius:3px;-moz-border-radius:3px;border-radius:3px}code{padding:2px 4px;color:#d14;background-color:#f7f7f9;border:1px solid #e1e1e8}pre{display:block;padding:8.5px;margin:0 0 9px;font-size:12.025px;line-height:18px;word-break:break-all;word-wrap:break-word;white-space:pre;white-space:pre-wrap;background-color:#f5f5f5;border:1px solid #ccc;border:1px solid rgba(0,0,0,0.15);-webkit-border-radius:4px;-moz-border-radius:4px;border-radius:4px}pre.prettyprint{margin-bottom:18px}pre code{padding:0;color:inherit;background-color:transparent;border:0}.pre-scrollable{max-height:340px;overflow-y:scroll}form{margin:0 0 18px}fieldset{padding:0;margin:0;border:0}legend{display:block;width:100%;padding:0;margin-bottom:27px;font-size:19.5px;line-height:36px;color:#333;border:0;border-bottom:1px solid #e5e5e5}legend small{font-size:13.5px;color:#999}label,input,button,select,textarea{font-size:13px;font-weight:normal;line-height:18px}input,button,select,textarea{font-family:"Helvetica Neue",Helvetica,Arial,sans-serif}label{display:block;margin-bottom:5px}select,textarea,input[type="text"],input[type="password"],input[type="datetime"],input[type="datetime-local"],input[type="date"],input[type="month"],input[type="time"],input[type="week"],input[type="number"],input[type="email"],input[type="url"],input[type="search"],input[type="tel"],input[type="color"],.uneditable-input{display:inline-block;height:18px;padding:4px;margin-bottom:9px;font-size:13px;line-height:18px;color:#555}input,textarea{width:210px}textarea{height:auto}textarea,input[type="text"],input[type="password"],input[type="datetime"],input[type="datetime-local"],input[type="date"],input[type="month"],input[type="time"],input[type="week"],input[type="number"],input[type="email"],input[type="url"],input[type="search"],input[type="tel"],input[type="color"],.uneditable-input{background-color:#fff;border:1px solid #c9d7e0;-webkit-border-radius:3px;-moz-border-radius:3px;border-radius:3px;-webkit-box-shadow:inset 0 1px 1px rgba(0,0,0,0.075);-moz-box-shadow:inset 0 1px 1px rgba(0,0,0,0.075);box-shadow:inset 0 1px 1px rgba(0,0,0,0.075);-webkit-transition:border linear .2s,box-shadow linear .2s;-moz-transition:border linear .2s,box-shadow linear .2s;-ms-transition:border linear .2s,box-shadow linear .2s;-o-transition:border linear .2s,box-shadow linear .2s;transition:border linear .2s,box-shadow linear .2s}textarea:focus,input[type="text"]:focus,input[type="password"]:focus,input[type="datetime"]:focus,input[type="datetime-local"]:focus,input[type="date"]:focus,input[type="month"]:focus,input[type="time"]:focus,input[type="week"]:focus,input[type="number"]:focus,input[type="email"]:focus,input[type="url"]:focus,input[type="search"]:focus,input[type="tel"]:focus,input[type="color"]:focus,.uneditable-input:focus{border-color:rgba(82,168,236,0.8);outline:0;outline:thin dotted \9;-webkit-box-shadow:inset 0 1px 1px rgba(0,0,0,0.075),0 0 8px rgba(82,168,236,0.6);-moz-box-shadow:inset 0 1px 1px rgba(0,0,0,0.075),0 0 8px rgba(82,168,236,0.6);box-shadow:inset 0 1px 1px rgba(0,0,0,0.075),0 0 8px rgba(82,168,236,0.6)}input[type="radio"],input[type="checkbox"]{margin:3px 0;*margin-top:0;line-height:normal;cursor:pointer}input[type="submit"],input[type="reset"],input[type="button"],input[type="radio"],input[type="checkbox"]{width:auto}.uneditable-textarea{width:auto;height:auto}select,input[type="file"]{height:28px;*margin-top:4px;line-height:28px}select{width:220px;border:1px solid #bbb}select[multiple],select[size]{height:auto}select:focus,input[type="file"]:focus,input[type="radio"]:focus,input[type="checkbox"]:focus{outline:thin dotted #333;outline:5px auto -webkit-focus-ring-color;outline-offset:-2px}.radio,.checkbox{min-height:18px;padding-left:18px}.radio input[type="radio"],.checkbox input[type="checkbox"]{float:left;margin-left:-18px}.controls>.radio:first-child,.controls>.checkbox:first-child{padding-top:5px}.radio.inline,.checkbox.inline{display:inline-block;padding-top:5px;margin-bottom:0;vertical-align:middle}.radio.inline+.radio.inline,.checkbox.inline+.checkbox.inline{margin-left:10px}.input-mini{width:60px}.input-small{width:90px}.input-medium{width:150px}.input-large{width:210px}.input-xlarge{width:270px}.input-xxlarge{width:530px}input[class*="span"],select[class*="span"],textarea[class*="span"],.uneditable-input[class*="span"],.row-fluid input[class*="span"],.row-fluid select[class*="span"],.row-fluid textarea[class*="span"],.row-fluid .uneditable-input[class*="span"]{float:none;margin-left:0}.input-append input[class*="span"],.input-append .uneditable-input[class*="span"],.input-prepend input[class*="span"],.input-prepend .uneditable-input[class*="span"],.row-fluid .input-prepend [class*="span"],.row-fluid .input-append [class*="span"]{display:inline-block}input,textarea,.uneditable-input{margin-left:0}input.span12,textarea.span12,.uneditable-input.span12{width:930px}input.span11,textarea.span11,.uneditable-input.span11{width:850px}input.span10,textarea.span10,.uneditable-input.span10{width:770px}input.span9,textarea.span9,.uneditable-input.span9{width:690px}input.span8,textarea.span8,.uneditable-input.span8{width:610px}input.span7,textarea.span7,.uneditable-input.span7{width:530px}input.span6,textarea.span6,.uneditable-input.span6{width:450px}input.span5,textarea.span5,.uneditable-input.span5{width:370px}input.span4,textarea.span4,.uneditable-input.span4{width:290px}input.span3,textarea.span3,.uneditable-input.span3{width:210px}input.span2,textarea.span2,.uneditable-input.span2{width:130px}input.span1,textarea.span1,.uneditable-input.span1{width:50px}input[disabled],select[disabled],textarea[disabled],input[readonly],select[readonly],textarea[readonly]{cursor:not-allowed;background-color:#eee;border-color:#ddd}input[type="radio"][disabled],input[type="checkbox"][disabled],input[type="radio"][readonly],input[type="checkbox"][readonly]{background-color:transparent}.control-group.warning>label,.control-group.warning .help-block,.control-group.warning .help-inline{color:#c09853}.control-group.warning .checkbox,.control-group.warning .radio,.control-group.warning input,.control-group.warning select,.control-group.warning textarea{color:#c09853;border-color:#c09853}.control-group.warning .checkbox:focus,.control-group.warning .radio:focus,.control-group.warning input:focus,.control-group.warning select:focus,.control-group.warning textarea:focus{border-color:#a47e3c;-webkit-box-shadow:0 0 6px #dbc59e;-moz-box-shadow:0 0 6px #dbc59e;box-shadow:0 0 6px #dbc59e}.control-group.warning .input-prepend .add-on,.control-group.warning .input-append .add-on{color:#c09853;background-color:#fcf8e3;border-color:#c09853}.control-group.error>label,.control-group.error .help-block,.control-group.error .help-inline{color:#b94a48}.control-group.error .checkbox,.control-group.error .radio,.control-group.error input,.control-group.error select,.control-group.error textarea{color:#b94a48;border-color:#b94a48}.control-group.error .checkbox:focus,.control-group.error .radio:focus,.control-group.error input:focus,.control-group.error select:focus,.control-group.error textarea:focus{border-color:#953b39;-webkit-box-shadow:0 0 6px #d59392;-moz-box-shadow:0 0 6px #d59392;box-shadow:0 0 6px #d59392}.control-group.error .input-prepend .add-on,.control-group.error .input-append .add-on{color:#b94a48;background-color:#f2dede;border-color:#b94a48}.control-group.success>label,.control-group.success .help-block,.control-group.success .help-inline{color:#468847}.control-group.success .checkbox,.control-group.success .radio,.control-group.success input,.control-group.success select,.control-group.success textarea{color:#468847;border-color:#468847}.control-group.success .checkbox:focus,.control-group.success .radio:focus,.control-group.success input:focus,.control-group.success select:focus,.control-group.success textarea:focus{border-color:#356635;-webkit-box-shadow:0 0 6px #7aba7b;-moz-box-shadow:0 0 6px #7aba7b;box-shadow:0 0 6px #7aba7b}.control-group.success .input-prepend .add-on,.control-group.success .input-append .add-on{color:#468847;background-color:#dff0d8;border-color:#468847}input:focus:required:invalid,textarea:focus:required:invalid,select:focus:required:invalid{color:#b94a48;border-color:#ee5f5b}input:focus:required:invalid:focus,textarea:focus:required:invalid:focus,select:focus:required:invalid:focus{border-color:#e9322d;-webkit-box-shadow:0 0 6px #f8b9b7;-moz-box-shadow:0 0 6px #f8b9b7;box-shadow:0 0 6px #f8b9b7}.form-actions{padding:17px 20px 18px;margin-top:18px;margin-bottom:18px;background-color:#f5f5f5;border-top:1px solid #e5e5e5;*zoom:1}.form-actions:before,.form-actions:after{display:table;content:""}.form-actions:after{clear:both}.uneditable-input{overflow:hidden;white-space:nowrap;cursor:not-allowed;background-color:#fff;border-color:#eee;-webkit-box-shadow:inset 0 1px 2px rgba(0,0,0,0.025);-moz-box-shadow:inset 0 1px 2px rgba(0,0,0,0.025);box-shadow:inset 0 1px 2px rgba(0,0,0,0.025)}:-moz-placeholder{color:#999}:-ms-input-placeholder{color:#999}::-webkit-input-placeholder{color:#999}.help-block,.help-inline{color:#555}.help-block{display:block;margin-bottom:9px}.help-inline{display:inline-block;*display:inline;padding-left:5px;vertical-align:middle;*zoom:1}.input-prepend,.input-append{margin-bottom:5px}.input-prepend input,.input-append input,.input-prepend select,.input-append select,.input-prepend .uneditable-input,.input-append .uneditable-input{position:relative;margin-bottom:0;*margin-left:0;vertical-align:middle;-webkit-border-radius:0 3px 3px 0;-moz-border-radius:0 3px 3px 0;border-radius:0 3px 3px 0}.input-prepend input:focus,.input-append input:focus,.input-prepend select:focus,.input-append select:focus,.input-prepend .uneditable-input:focus,.input-append .uneditable-input:focus{z-index:2}.input-prepend .uneditable-input,.input-append .uneditable-input{border-left-color:#ccc}.input-prepend .add-on,.input-append .add-on{display:inline-block;width:auto;height:18px;min-width:16px;padding:4px 5px;font-weight:normal;line-height:18px;text-align:center;text-shadow:0 1px 0 #fff;vertical-align:middle;background-color:#eee;border:1px solid #ccc}.input-prepend .add-on,.input-append .add-on,.input-prepend .btn,.input-append .btn{margin-left:-1px;-webkit-border-radius:0;-moz-border-radius:0;border-radius:0}.input-prepend .active,.input-append .active{background-color:#a9dba9;border-color:#46a546}.input-prepend .add-on,.input-prepend .btn{margin-right:-1px}.input-prepend .add-on:first-child,.input-prepend .btn:first-child{-webkit-border-radius:3px 0 0 3px;-moz-border-radius:3px 0 0 3px;border-radius:3px 0 0 3px}.input-append input,.input-append select,.input-append .uneditable-input{-webkit-border-radius:3px 0 0 3px;-moz-border-radius:3px 0 0 3px;border-radius:3px 0 0 3px}.input-append .uneditable-input{border-right-color:#ccc;border-left-color:#eee}.input-append .add-on:last-child,.input-append .btn:last-child{-webkit-border-radius:0 3px 3px 0;-moz-border-radius:0 3px 3px 0;border-radius:0 3px 3px 0}.input-prepend.input-append input,.input-prepend.input-append select,.input-prepend.input-append .uneditable-input{-webkit-border-radius:0;-moz-border-radius:0;border-radius:0}.input-prepend.input-append .add-on:first-child,.input-prepend.input-append .btn:first-child{margin-right:-1px;-webkit-border-radius:3px 0 0 3px;-moz-border-radius:3px 0 0 3px;border-radius:3px 0 0 3px}.input-prepend.input-append .add-on:last-child,.input-prepend.input-append .btn:last-child{margin-left:-1px;-webkit-border-radius:0 3px 3px 0;-moz-border-radius:0 3px 3px 0;border-radius:0 3px 3px 0}.search-query{padding-right:14px;padding-right:4px \9;padding-left:14px;padding-left:4px \9;margin-bottom:0;-webkit-border-radius:14px;-moz-border-radius:14px;border-radius:14px}.form-search input,.form-inline input,.form-horizontal input,.form-search textarea,.form-inline textarea,.form-horizontal textarea,.form-search select,.form-inline select,.form-horizontal select,.form-search .help-inline,.form-inline .help-inline,.form-horizontal .help-inline,.form-search .uneditable-input,.form-inline .uneditable-input,.form-horizontal .uneditable-input,.form-search .input-prepend,.form-inline .input-prepend,.form-horizontal .input-prepend,.form-search .input-append,.form-inline .input-append,.form-horizontal .input-append{display:inline-block;*display:inline;margin-bottom:0;*zoom:1}.form-search .hide,.form-inline .hide,.form-horizontal .hide{display:none}.form-search label,.form-inline label{display:inline-block}.form-search .input-append,.form-inline .input-append,.form-search .input-prepend,.form-inline .input-prepend{margin-bottom:0}.form-search .radio,.form-search .checkbox,.form-inline .radio,.form-inline .checkbox{padding-left:0;margin-bottom:0;vertical-align:middle}.form-search .radio input[type="radio"],.form-search .checkbox input[type="checkbox"],.form-inline .radio input[type="radio"],.form-inline .checkbox input[type="checkbox"]{float:left;margin-right:3px;margin-left:0}.control-group{margin-bottom:9px}legend+.control-group{margin-top:18px;-webkit-margin-top-collapse:separate}.form-horizontal .control-group{margin-bottom:18px;*zoom:1}.form-horizontal .control-group:before,.form-horizontal .control-group:after{display:table;content:""}.form-horizontal .control-group:after{clear:both}.form-horizontal .control-label{float:left;width:140px;padding-top:5px;text-align:right}.form-horizontal .controls{*display:inline-block;*padding-left:20px;margin-left:160px;*margin-left:0}.form-horizontal .controls:first-child{*padding-left:160px}.form-horizontal .help-block{margin-top:9px;margin-bottom:0}.form-horizontal .form-actions{padding-left:160px}table{max-width:100%;background-color:transparent;border-collapse:collapse;border-spacing:0}.table{width:100%;margin-bottom:18px}.table th,.table td{padding:8px;line-height:18px;text-align:left;vertical-align:top;border-top:1px solid #c9d7e0}.table th{font-weight:bold}.table thead th{vertical-align:bottom}.table caption+thead tr:first-child th,.table caption+thead tr:first-child td,.table colgroup+thead tr:first-child th,.table colgroup+thead tr:first-child td,.table thead:first-child tr:first-child th,.table thead:first-child tr:first-child td{border-top:0}.table tbody+tbody{border-top:2px solid #c9d7e0}.table-condensed th,.table-condensed td{padding:4px 5px}.table-bordered{border:1px solid #c9d7e0;border-collapse:separate;*border-collapse:collapsed;border-left:0;-webkit-border-radius:4px;-moz-border-radius:4px;border-radius:4px}.table-bordered th,.table-bordered td{border-left:1px solid #c9d7e0}.table-bordered caption+thead tr:first-child th,.table-bordered caption+tbody tr:first-child th,.table-bordered caption+tbody tr:first-child td,.table-bordered colgroup+thead tr:first-child th,.table-bordered colgroup+tbody tr:first-child th,.table-bordered colgroup+tbody tr:first-child td,.table-bordered thead:first-child tr:first-child th,.table-bordered tbody:first-child tr:first-child th,.table-bordered tbody:first-child tr:first-child td{border-top:0}.table-bordered thead:first-child tr:first-child th:first-child,.table-bordered tbody:first-child tr:first-child td:first-child{-webkit-border-top-left-radius:4px;border-top-left-radius:4px;-moz-border-radius-topleft:4px}.table-bordered thead:first-child tr:first-child th:last-child,.table-bordered tbody:first-child tr:first-child td:last-child{-webkit-border-top-right-radius:4px;border-top-right-radius:4px;-moz-border-radius-topright:4px}.table-bordered thead:last-child tr:last-child th:first-child,.table-bordered tbody:last-child tr:last-child td:first-child{-webkit-border-radius:0 0 0 4px;-moz-border-radius:0 0 0 4px;border-radius:0 0 0 4px;-webkit-border-bottom-left-radius:4px;border-bottom-left-radius:4px;-moz-border-radius-bottomleft:4px}.table-bordered thead:last-child tr:last-child th:last-child,.table-bordered tbody:last-child tr:last-child td:last-child{-webkit-border-bottom-right-radius:4px;border-bottom-right-radius:4px;-moz-border-radius-bottomright:4px}.table-striped tbody tr:nth-child(odd) td,.table-striped tbody tr:nth-child(odd) th{background-color:#edf3f7}.table tbody tr:hover td,.table tbody tr:hover th{background-color:#cde3f2}table .span1{float:none;width:44px;margin-left:0}table .span2{float:none;width:124px;margin-left:0}table .span3{float:none;width:204px;margin-left:0}table .span4{float:none;width:284px;margin-left:0}table .span5{float:none;width:364px;margin-left:0}table .span6{float:none;width:444px;margin-left:0}table .span7{float:none;width:524px;margin-left:0}table .span8{float:none;width:604px;margin-left:0}table .span9{float:none;width:684px;margin-left:0}table .span10{float:none;width:764px;margin-left:0}table .span11{float:none;width:844px;margin-left:0}table .span12{float:none;width:924px;margin-left:0}table .span13{float:none;width:1004px;margin-left:0}table .span14{float:none;width:1084px;margin-left:0}table .span15{float:none;width:1164px;margin-left:0}table .span16{float:none;width:1244px;margin-left:0}table .span17{float:none;width:1324px;margin-left:0}table .span18{float:none;width:1404px;margin-left:0}table .span19{float:none;width:1484px;margin-left:0}table .span20{float:none;width:1564px;margin-left:0}table .span21{float:none;width:1644px;margin-left:0}table .span22{float:none;width:1724px;margin-left:0}table .span23{float:none;width:1804px;margin-left:0}table .span24{float:none;width:1884px;margin-left:0}[class^="icon-"],[class*=" icon-"]{display:inline-block;width:14px;height:14px;*margin-right:.3em;line-height:14px;vertical-align:text-top;background-image:url("../img/glyphicons-halflings.png");background-position:14px 14px;background-repeat:no-repeat}[class^="icon-"]:last-child,[class*=" icon-"]:last-child{*margin-left:0}.icon-white{background-image:url("../img/glyphicons-halflings-white.png")}.icon-glass{background-position:0 0}.icon-music{background-position:-24px 0}.icon-search{background-position:-48px 0}.icon-envelope{background-position:-72px 0}.icon-heart{background-position:-96px 0}.icon-star{background-position:-120px 0}.icon-star-empty{background-position:-144px 0}.icon-user{background-position:-168px 0}.icon-film{background-position:-192px 0}.icon-th-large{background-position:-216px 0}.icon-th{background-position:-240px 0}.icon-th-list{background-position:-264px 0}.icon-ok{background-position:-288px 0}.icon-remove{background-position:-312px 0}.icon-zoom-in{background-position:-336px 0}.icon-zoom-out{background-position:-360px 0}.icon-off{background-position:-384px 0}.icon-signal{background-position:-408px 0}.icon-cog{background-position:-432px 0}.icon-trash{background-position:-456px 0}.icon-home{background-position:0 -24px}.icon-file{background-position:-24px -24px}.icon-time{background-position:-48px -24px}.icon-road{background-position:-72px -24px}.icon-download-alt{background-position:-96px -24px}.icon-download{background-position:-120px -24px}.icon-upload{background-position:-144px -24px}.icon-inbox{background-position:-168px -24px}.icon-play-circle{background-position:-192px -24px}.icon-repeat{background-position:-216px -24px}.icon-refresh{background-position:-240px -24px}.icon-list-alt{background-position:-264px -24px}.icon-lock{background-position:-287px -24px}.icon-flag{background-position:-312px -24px}.icon-headphones{background-position:-336px -24px}.icon-volume-off{background-position:-360px -24px}.icon-volume-down{background-position:-384px -24px}.icon-volume-up{background-position:-408px -24px}.icon-qrcode{background-position:-432px -24px}.icon-barcode{background-position:-456px -24px}.icon-tag{background-position:0 -48px}.icon-tags{background-position:-25px -48px}.icon-book{background-position:-48px -48px}.icon-bookmark{background-position:-72px -48px}.icon-print{background-position:-96px -48px}.icon-camera{background-position:-120px -48px}.icon-font{background-position:-144px -48px}.icon-bold{background-position:-167px -48px}.icon-italic{background-position:-192px -48px}.icon-text-height{background-position:-216px -48px}.icon-text-width{background-position:-240px -48px}.icon-align-left{background-position:-264px -48px}.icon-align-center{background-position:-288px -48px}.icon-align-right{background-position:-312px -48px}.icon-align-justify{background-position:-336px -48px}.icon-list{background-position:-360px -48px}.icon-indent-left{background-position:-384px -48px}.icon-indent-right{background-position:-408px -48px}.icon-facetime-video{background-position:-432px -48px}.icon-picture{background-position:-456px -48px}.icon-pencil{background-position:0 -72px}.icon-map-marker{background-position:-24px -72px}.icon-adjust{background-position:-48px -72px}.icon-tint{background-position:-72px -72px}.icon-edit{background-position:-96px -72px}.icon-share{background-position:-120px -72px}.icon-check{background-position:-144px -72px}.icon-move{background-position:-168px -72px}.icon-step-backward{background-position:-192px -72px}.icon-fast-backward{background-position:-216px -72px}.icon-backward{background-position:-240px -72px}.icon-play{background-position:-264px -72px}.icon-pause{background-position:-288px -72px}.icon-stop{background-position:-312px -72px}.icon-forward{background-position:-336px -72px}.icon-fast-forward{background-position:-360px -72px}.icon-step-forward{background-position:-384px -72px}.icon-eject{background-position:-408px -72px}.icon-chevron-left{background-position:-432px -72px}.icon-chevron-right{background-position:-456px -72px}.icon-plus-sign{background-position:0 -96px}.icon-minus-sign{background-position:-24px -96px}.icon-remove-sign{background-position:-48px -96px}.icon-ok-sign{background-position:-72px -96px}.icon-question-sign{background-position:-96px -96px}.icon-info-sign{background-position:-120px -96px}.icon-screenshot{background-position:-144px -96px}.icon-remove-circle{background-position:-168px -96px}.icon-ok-circle{background-position:-192px -96px}.icon-ban-circle{background-position:-216px -96px}.icon-arrow-left{background-position:-240px -96px}.icon-arrow-right{background-position:-264px -96px}.icon-arrow-up{background-position:-289px -96px}.icon-arrow-down{background-position:-312px -96px}.icon-share-alt{background-position:-336px -96px}.icon-resize-full{background-position:-360px -96px}.icon-resize-small{background-position:-384px -96px}.icon-plus{background-position:-408px -96px}.icon-minus{background-position:-433px -96px}.icon-asterisk{background-position:-456px -96px}.icon-exclamation-sign{background-position:0 -120px}.icon-gift{background-position:-24px -120px}.icon-leaf{background-position:-48px -120px}.icon-fire{background-position:-72px -120px}.icon-eye-open{background-position:-96px -120px}.icon-eye-close{background-position:-120px -120px}.icon-warning-sign{background-position:-144px -120px}.icon-plane{background-position:-168px -120px}.icon-calendar{background-position:-192px -120px}.icon-random{background-position:-216px -120px}.icon-comment{background-position:-240px -120px}.icon-magnet{background-position:-264px -120px}.icon-chevron-up{background-position:-288px -120px}.icon-chevron-down{background-position:-313px -119px}.icon-retweet{background-position:-336px -120px}.icon-shopping-cart{background-position:-360px -120px}.icon-folder-close{background-position:-384px -120px}.icon-folder-open{background-position:-408px -120px}.icon-resize-vertical{background-position:-432px -119px}.icon-resize-horizontal{background-position:-456px -118px}.icon-hdd{background-position:0 -144px}.icon-bullhorn{background-position:-24px -144px}.icon-bell{background-position:-48px -144px}.icon-certificate{background-position:-72px -144px}.icon-thumbs-up{background-position:-96px -144px}.icon-thumbs-down{background-position:-120px -144px}.icon-hand-right{background-position:-144px -144px}.icon-hand-left{background-position:-168px -144px}.icon-hand-up{background-position:-192px -144px}.icon-hand-down{background-position:-216px -144px}.icon-circle-arrow-right{background-position:-240px -144px}.icon-circle-arrow-left{background-position:-264px -144px}.icon-circle-arrow-up{background-position:-288px -144px}.icon-circle-arrow-down{background-position:-312px -144px}.icon-globe{background-position:-336px -144px}.icon-wrench{background-position:-360px -144px}.icon-tasks{background-position:-384px -144px}.icon-filter{background-position:-408px -144px}.icon-briefcase{background-position:-432px -144px}.icon-fullscreen{background-position:-456px -144px}.dropup,.dropdown{position:relative}.dropdown-toggle{*margin-bottom:-3px}.dropdown-toggle:active,.open .dropdown-toggle{outline:0}.caret{display:inline-block;width:0;height:0;vertical-align:top;border-top:4px solid #000;border-right:4px solid transparent;border-left:4px solid transparent;content:"";opacity:.3;filter:alpha(opacity=30)}.dropdown .caret{margin-top:8px;margin-left:2px}.dropdown:hover .caret,.open .caret{opacity:1;filter:alpha(opacity=100)}.dropdown-menu{position:absolute;top:100%;left:0;z-index:1000;display:none;float:left;min-width:160px;padding:4px 0;margin:1px 0 0;list-style:none;background-color:#fff;border:1px solid #ccc;border:1px solid rgba(0,0,0,0.2);*border-right-width:2px;*border-bottom-width:2px;-webkit-border-radius:5px;-moz-border-radius:5px;border-radius:5px;-webkit-box-shadow:0 5px 10px rgba(0,0,0,0.2);-moz-box-shadow:0 5px 10px rgba(0,0,0,0.2);box-shadow:0 5px 10px rgba(0,0,0,0.2);-webkit-background-clip:padding-box;-moz-background-clip:padding;background-clip:padding-box}.dropdown-menu.pull-right{right:0;left:auto}.dropdown-menu .divider{*width:100%;height:1px;margin:8px 1px;*margin:-5px 0 5px;overflow:hidden;background-color:#e5e5e5;border-bottom:1px solid #fff}.dropdown-menu a{display:block;padding:3px 15px;clear:both;font-weight:normal;line-height:18px;color:#333;white-space:nowrap}.dropdown-menu li>a:hover,.dropdown-menu .active>a,.dropdown-menu .active>a:hover{color:#fff;text-decoration:none;background-color:#003482}.open{*z-index:1000}.open>.dropdown-menu{display:block}.pull-right>.dropdown-menu{right:0;left:auto}.dropup .caret,.navbar-fixed-bottom .dropdown .caret{border-top:0;border-bottom:4px solid #000;content:"\2191"}.dropup .dropdown-menu,.navbar-fixed-bottom .dropdown .dropdown-menu{top:auto;bottom:100%;margin-bottom:1px}.typeahead{margin-top:2px;-webkit-border-radius:4px;-moz-border-radius:4px;border-radius:4px}.well{min-height:20px;padding:19px;margin-bottom:20px;background-color:#f5f5f5;border:1px solid #eee;border:1px solid rgba(0,0,0,0.05);-webkit-border-radius:4px;-moz-border-radius:4px;border-radius:4px;-webkit-box-shadow:inset 0 1px 1px rgba(0,0,0,0.05);-moz-box-shadow:inset 0 1px 1px rgba(0,0,0,0.05);box-shadow:inset 0 1px 1px rgba(0,0,0,0.05)}.well blockquote{border-color:#ddd;border-color:rgba(0,0,0,0.15)}.well-large{padding:24px;-webkit-border-radius:6px;-moz-border-radius:6px;border-radius:6px}.well-small{padding:9px;-webkit-border-radius:3px;-moz-border-radius:3px;border-radius:3px}.fade{opacity:0;-webkit-transition:opacity .15s linear;-moz-transition:opacity .15s linear;-ms-transition:opacity .15s linear;-o-transition:opacity .15s linear;transition:opacity .15s linear}.fade.in{opacity:1}.collapse{position:relative;height:0;overflow:hidden;-webkit-transition:height .35s ease;-moz-transition:height .35s ease;-ms-transition:height .35s ease;-o-transition:height .35s ease;transition:height .35s ease}.collapse.in{height:auto}.close{float:right;font-size:20px;font-weight:bold;line-height:18px;color:#000;text-shadow:0 1px 0 #fff;opacity:.2;filter:alpha(opacity=20)}.close:hover{color:#000;text-decoration:none;cursor:pointer;opacity:.4;filter:alpha(opacity=40)}button.close{padding:0;cursor:pointer;background:transparent;border:0;-webkit-appearance:none}.btn{display:inline-block;*display:inline;padding:4px 10px 4px;margin-bottom:0;*margin-left:.3em;font-size:13px;line-height:18px;*line-height:20px;color:#333;text-align:center;text-shadow:0 1px 1px rgba(255,255,255,0.75);vertical-align:middle;cursor:pointer;background-color:#f5f5f5;*background-color:#e6e6e6;background-image:-ms-linear-gradient(top,#fff,#e6e6e6);background-image:-webkit-gradient(linear,0 0,0 100%,from(#fff),to(#e6e6e6));background-image:-webkit-linear-gradient(top,#fff,#e6e6e6);background-image:-o-linear-gradient(top,#fff,#e6e6e6);background-image:linear-gradient(top,#fff,#e6e6e6);background-image:-moz-linear-gradient(top,#fff,#e6e6e6);background-repeat:repeat-x;border:1px solid #ccc;*border:0;border-color:rgba(0,0,0,0.1) rgba(0,0,0,0.1) rgba(0,0,0,0.25);border-color:#e6e6e6 #e6e6e6 #bfbfbf;border-bottom-color:#b3b3b3;-webkit-border-radius:4px;-moz-border-radius:4px;border-radius:4px;filter:progid:dximagetransform.microsoft.gradient(startColorstr='#ffffff',endColorstr='#e6e6e6',GradientType=0);filter:progid:dximagetransform.microsoft.gradient(enabled=false);*zoom:1;-webkit-box-shadow:inset 0 1px 0 rgba(255,255,255,0.2),0 1px 2px rgba(0,0,0,0.05);-moz-box-shadow:inset 0 1px 0 rgba(255,255,255,0.2),0 1px 2px rgba(0,0,0,0.05);box-shadow:inset 0 1px 0 rgba(255,255,255,0.2),0 1px 2px rgba(0,0,0,0.05)}.btn:hover,.btn:active,.btn.active,.btn.disabled,.btn[disabled]{background-color:#e6e6e6;*background-color:#d9d9d9}.btn:active,.btn.active{background-color:#ccc \9}.btn:first-child{*margin-left:0}.btn:hover{color:#333;text-decoration:none;background-color:#e6e6e6;*background-color:#d9d9d9;background-position:0 -15px;-webkit-transition:background-position .1s linear;-moz-transition:background-position .1s linear;-ms-transition:background-position .1s linear;-o-transition:background-position .1s linear;transition:background-position .1s linear}.btn:focus{outline:thin dotted #333;outline:5px auto -webkit-focus-ring-color;outline-offset:-2px}.btn.active,.btn:active{background-color:#e6e6e6;background-color:#d9d9d9 \9;background-image:none;outline:0;-webkit-box-shadow:inset 0 2px 4px rgba(0,0,0,0.15),0 1px 2px rgba(0,0,0,0.05);-moz-box-shadow:inset 0 2px 4px rgba(0,0,0,0.15),0 1px 2px rgba(0,0,0,0.05);box-shadow:inset 0 2px 4px rgba(0,0,0,0.15),0 1px 2px rgba(0,0,0,0.05)}.btn.disabled,.btn[disabled]{cursor:default;background-color:#e6e6e6;background-image:none;opacity:.65;filter:alpha(opacity=65);-webkit-box-shadow:none;-moz-box-shadow:none;box-shadow:none}.btn-large{padding:9px 14px;font-size:15px;line-height:normal;-webkit-border-radius:5px;-moz-border-radius:5px;border-radius:5px}.btn-large [class^="icon-"]{margin-top:1px}.btn-small{padding:5px 9px;font-size:11px;line-height:16px}.btn-small [class^="icon-"]{margin-top:-1px}.btn-mini{padding:2px 6px;font-size:11px;line-height:14px}.btn-primary,.btn-primary:hover,.btn-warning,.btn-warning:hover,.btn-danger,.btn-danger:hover,.btn-success,.btn-success:hover,.btn-info,.btn-info:hover,.btn-inverse,.btn-inverse:hover{color:#fff;text-shadow:0 -1px 0 rgba(0,0,0,0.25)}.btn-primary.active,.btn-warning.active,.btn-danger.active,.btn-success.active,.btn-info.active,.btn-inverse.active{color:rgba(255,255,255,0.75)}.btn{border-color:#ccc;border-color:rgba(0,0,0,0.1) rgba(0,0,0,0.1) rgba(0,0,0,0.25)}.btn-primary{background-color:#0074cc;*background-color:#05c;background-image:-ms-linear-gradient(top,#08c,#05c);background-image:-webkit-gradient(linear,0 0,0 100%,from(#08c),to(#05c));background-image:-webkit-linear-gradient(top,#08c,#05c);background-image:-o-linear-gradient(top,#08c,#05c);background-image:-moz-linear-gradient(top,#08c,#05c);background-image:linear-gradient(top,#08c,#05c);background-repeat:repeat-x;border-color:#05c #05c #003580;border-color:rgba(0,0,0,0.1) rgba(0,0,0,0.1) rgba(0,0,0,0.25);filter:progid:dximagetransform.microsoft.gradient(startColorstr='#0088cc',endColorstr='#0055cc',GradientType=0);filter:progid:dximagetransform.microsoft.gradient(enabled=false)}.btn-primary:hover,.btn-primary:active,.btn-primary.active,.btn-primary.disabled,.btn-primary[disabled]{background-color:#05c;*background-color:#004ab3}.btn-primary:active,.btn-primary.active{background-color:#004099 \9}.btn-warning{background-color:#faa732;*background-color:#f89406;background-image:-ms-linear-gradient(top,#fbb450,#f89406);background-image:-webkit-gradient(linear,0 0,0 100%,from(#fbb450),to(#f89406));background-image:-webkit-linear-gradient(top,#fbb450,#f89406);background-image:-o-linear-gradient(top,#fbb450,#f89406);background-image:-moz-linear-gradient(top,#fbb450,#f89406);background-image:linear-gradient(top,#fbb450,#f89406);background-repeat:repeat-x;border-color:#f89406 #f89406 #ad6704;border-color:rgba(0,0,0,0.1) rgba(0,0,0,0.1) rgba(0,0,0,0.25);filter:progid:dximagetransform.microsoft.gradient(startColorstr='#fbb450',endColorstr='#f89406',GradientType=0);filter:progid:dximagetransform.microsoft.gradient(enabled=false)}.btn-warning:hover,.btn-warning:active,.btn-warning.active,.btn-warning.disabled,.btn-warning[disabled]{background-color:#f89406;*background-color:#df8505}.btn-warning:active,.btn-warning.active{background-color:#c67605 \9}.btn-danger{background-color:#da4f49;*background-color:#bd362f;background-image:-ms-linear-gradient(top,#ee5f5b,#bd362f);background-image:-webkit-gradient(linear,0 0,0 100%,from(#ee5f5b),to(#bd362f));background-image:-webkit-linear-gradient(top,#ee5f5b,#bd362f);background-image:-o-linear-gradient(top,#ee5f5b,#bd362f);background-image:-moz-linear-gradient(top,#ee5f5b,#bd362f);background-image:linear-gradient(top,#ee5f5b,#bd362f);background-repeat:repeat-x;border-color:#bd362f #bd362f #802420;border-color:rgba(0,0,0,0.1) rgba(0,0,0,0.1) rgba(0,0,0,0.25);filter:progid:dximagetransform.microsoft.gradient(startColorstr='#ee5f5b',endColorstr='#bd362f',GradientType=0);filter:progid:dximagetransform.microsoft.gradient(enabled=false)}.btn-danger:hover,.btn-danger:active,.btn-danger.active,.btn-danger.disabled,.btn-danger[disabled]{background-color:#bd362f;*background-color:#a9302a}.btn-danger:active,.btn-danger.active{background-color:#942a25 \9}.btn-success{background-color:#5bb75b;*background-color:#51a351;background-image:-ms-linear-gradient(top,#62c462,#51a351);background-image:-webkit-gradient(linear,0 0,0 100%,from(#62c462),to(#51a351));background-image:-webkit-linear-gradient(top,#62c462,#51a351);background-image:-o-linear-gradient(top,#62c462,#51a351);background-image:-moz-linear-gradient(top,#62c462,#51a351);background-image:linear-gradient(top,#62c462,#51a351);background-repeat:repeat-x;border-color:#51a351 #51a351 #387038;border-color:rgba(0,0,0,0.1) rgba(0,0,0,0.1) rgba(0,0,0,0.25);filter:progid:dximagetransform.microsoft.gradient(startColorstr='#62c462',endColorstr='#51a351',GradientType=0);filter:progid:dximagetransform.microsoft.gradient(enabled=false)}.btn-success:hover,.btn-success:active,.btn-success.active,.btn-success.disabled,.btn-success[disabled]{background-color:#51a351;*background-color:#499249}.btn-success:active,.btn-success.active{background-color:#408140 \9}.btn-info{background-color:#49afcd;*background-color:#2f96b4;background-image:-ms-linear-gradient(top,#5bc0de,#2f96b4);background-image:-webkit-gradient(linear,0 0,0 100%,from(#5bc0de),to(#2f96b4));background-image:-webkit-linear-gradient(top,#5bc0de,#2f96b4);background-image:-o-linear-gradient(top,#5bc0de,#2f96b4);background-image:-moz-linear-gradient(top,#5bc0de,#2f96b4);background-image:linear-gradient(top,#5bc0de,#2f96b4);background-repeat:repeat-x;border-color:#2f96b4 #2f96b4 #1f6377;border-color:rgba(0,0,0,0.1) rgba(0,0,0,0.1) rgba(0,0,0,0.25);filter:progid:dximagetransform.microsoft.gradient(startColorstr='#5bc0de',endColorstr='#2f96b4',GradientType=0);filter:progid:dximagetransform.microsoft.gradient(enabled=false)}.btn-info:hover,.btn-info:active,.btn-info.active,.btn-info.disabled,.btn-info[disabled]{background-color:#2f96b4;*background-color:#2a85a0}.btn-info:active,.btn-info.active{background-color:#24748c \9}.btn-inverse{background-color:#414141;*background-color:#222;background-image:-ms-linear-gradient(top,#555,#222);background-image:-webkit-gradient(linear,0 0,0 100%,from(#555),to(#222));background-image:-webkit-linear-gradient(top,#555,#222);background-image:-o-linear-gradient(top,#555,#222);background-image:-moz-linear-gradient(top,#555,#222);background-image:linear-gradient(top,#555,#222);background-repeat:repeat-x;border-color:#222 #222 #000;border-color:rgba(0,0,0,0.1) rgba(0,0,0,0.1) rgba(0,0,0,0.25);filter:progid:dximagetransform.microsoft.gradient(startColorstr='#555555',endColorstr='#222222',GradientType=0);filter:progid:dximagetransform.microsoft.gradient(enabled=false)}.btn-inverse:hover,.btn-inverse:active,.btn-inverse.active,.btn-inverse.disabled,.btn-inverse[disabled]{background-color:#222;*background-color:#151515}.btn-inverse:active,.btn-inverse.active{background-color:#080808 \9}button.btn,input[type="submit"].btn{*padding-top:2px;*padding-bottom:2px}button.btn::-moz-focus-inner,input[type="submit"].btn::-moz-focus-inner{padding:0;border:0}button.btn.btn-large,input[type="submit"].btn.btn-large{*padding-top:7px;*padding-bottom:7px}button.btn.btn-small,input[type="submit"].btn.btn-small{*padding-top:3px;*padding-bottom:3px}button.btn.btn-mini,input[type="submit"].btn.btn-mini{*padding-top:1px;*padding-bottom:1px}.btn-group{position:relative;*margin-left:.3em;*zoom:1}.btn-group:before,.btn-group:after{display:table;content:""}.btn-group:after{clear:both}.btn-group:first-child{*margin-left:0}.btn-group+.btn-group{margin-left:5px}.btn-toolbar{margin-top:9px;margin-bottom:9px}.btn-toolbar .btn-group{display:inline-block;*display:inline;*zoom:1}.btn-group>.btn{position:relative;float:left;margin-left:-1px;-webkit-border-radius:0;-moz-border-radius:0;border-radius:0}.btn-group>.btn:first-child{margin-left:0;-webkit-border-bottom-left-radius:4px;border-bottom-left-radius:4px;-webkit-border-top-left-radius:4px;border-top-left-radius:4px;-moz-border-radius-bottomleft:4px;-moz-border-radius-topleft:4px}.btn-group>.btn:last-child,.btn-group>.dropdown-toggle{-webkit-border-top-right-radius:4px;border-top-right-radius:4px;-webkit-border-bottom-right-radius:4px;border-bottom-right-radius:4px;-moz-border-radius-topright:4px;-moz-border-radius-bottomright:4px}.btn-group>.btn.large:first-child{margin-left:0;-webkit-border-bottom-left-radius:6px;border-bottom-left-radius:6px;-webkit-border-top-left-radius:6px;border-top-left-radius:6px;-moz-border-radius-bottomleft:6px;-moz-border-radius-topleft:6px}.btn-group>.btn.large:last-child,.btn-group>.large.dropdown-toggle{-webkit-border-top-right-radius:6px;border-top-right-radius:6px;-webkit-border-bottom-right-radius:6px;border-bottom-right-radius:6px;-moz-border-radius-topright:6px;-moz-border-radius-bottomright:6px}.btn-group>.btn:hover,.btn-group>.btn:focus,.btn-group>.btn:active,.btn-group>.btn.active{z-index:2}.btn-group .dropdown-toggle:active,.btn-group.open .dropdown-toggle{outline:0}.btn-group>.dropdown-toggle{*padding-top:4px;padding-right:8px;*padding-bottom:4px;padding-left:8px;-webkit-box-shadow:inset 1px 0 0 rgba(255,255,255,0.125),inset 0 1px 0 rgba(255,255,255,0.2),0 1px 2px rgba(0,0,0,0.05);-moz-box-shadow:inset 1px 0 0 rgba(255,255,255,0.125),inset 0 1px 0 rgba(255,255,255,0.2),0 1px 2px rgba(0,0,0,0.05);box-shadow:inset 1px 0 0 rgba(255,255,255,0.125),inset 0 1px 0 rgba(255,255,255,0.2),0 1px 2px rgba(0,0,0,0.05)}.btn-group>.btn-mini.dropdown-toggle{padding-right:5px;padding-left:5px}.btn-group>.btn-small.dropdown-toggle{*padding-top:4px;*padding-bottom:4px}.btn-group>.btn-large.dropdown-toggle{padding-right:12px;padding-left:12px}.btn-group.open .dropdown-toggle{background-image:none;-webkit-box-shadow:inset 0 2px 4px rgba(0,0,0,0.15),0 1px 2px rgba(0,0,0,0.05);-moz-box-shadow:inset 0 2px 4px rgba(0,0,0,0.15),0 1px 2px rgba(0,0,0,0.05);box-shadow:inset 0 2px 4px rgba(0,0,0,0.15),0 1px 2px rgba(0,0,0,0.05)}.btn-group.open .btn.dropdown-toggle{background-color:#e6e6e6}.btn-group.open .btn-primary.dropdown-toggle{background-color:#05c}.btn-group.open .btn-warning.dropdown-toggle{background-color:#f89406}.btn-group.open .btn-danger.dropdown-toggle{background-color:#bd362f}.btn-group.open .btn-success.dropdown-toggle{background-color:#51a351}.btn-group.open .btn-info.dropdown-toggle{background-color:#2f96b4}.btn-group.open .btn-inverse.dropdown-toggle{background-color:#222}.btn .caret{margin-top:7px;margin-left:0}.btn:hover .caret,.open.btn-group .caret{opacity:1;filter:alpha(opacity=100)}.btn-mini .caret{margin-top:5px}.btn-small .caret{margin-top:6px}.btn-large .caret{margin-top:6px;border-top-width:5px;border-right-width:5px;border-left-width:5px}.dropup .btn-large .caret{border-top:0;border-bottom:5px solid #000}.btn-primary .caret,.btn-warning .caret,.btn-danger .caret,.btn-info .caret,.btn-success .caret,.btn-inverse .caret{border-top-color:#fff;border-bottom-color:#fff;opacity:.75;filter:alpha(opacity=75)}.alert{padding:8px 35px 8px 14px;margin-bottom:18px;color:#c09853;text-shadow:0 1px 0 rgba(255,255,255,0.5);background-color:#fcf8e3;border:1px solid #fbeed5;-webkit-border-radius:4px;-moz-border-radius:4px;border-radius:4px}.alert-heading{color:inherit}.alert .close{position:relative;top:-2px;right:-21px;line-height:18px}.alert-success{color:#468847;background-color:#dff0d8;border-color:#d6e9c6}.alert-danger,.alert-error{color:#b94a48;background-color:#f2dede;border-color:#eed3d7}.alert-info{color:#3a87ad;background-color:#d9edf7;border-color:#bce8f1}.alert-block{padding-top:14px;padding-bottom:14px}.alert-block>p,.alert-block>ul{margin-bottom:0}.alert-block p+p{margin-top:5px}.nav{margin-bottom:18px;margin-left:0;list-style:none}.nav>li>a{display:block}.nav>li>a:hover{text-decoration:none;background-color:#eee}.nav>.pull-right{float:right}.nav .nav-header{display:block;padding:3px 15px;font-size:11px;font-weight:bold;line-height:18px;color:#999;text-shadow:0 1px 0 rgba(255,255,255,0.5);text-transform:uppercase}.nav li+.nav-header{margin-top:9px}.nav-list{padding-right:15px;padding-left:15px;margin-bottom:0}.nav-list>li>a,.nav-list .nav-header{margin-right:-15px;margin-left:-15px;text-shadow:0 1px 0 rgba(255,255,255,0.5)}.nav-list>li>a{padding:3px 15px}.nav-list>.active>a,.nav-list>.active>a:hover{color:#fff;text-shadow:0 -1px 0 rgba(0,0,0,0.2);background-color:#08c}.nav-list [class^="icon-"]{margin-right:2px}.nav-list .divider{*width:100%;height:1px;margin:8px 1px;*margin:-5px 0 5px;overflow:hidden;background-color:#e5e5e5;border-bottom:1px solid #fff}.nav-tabs,.nav-pills{*zoom:1}.nav-tabs:before,.nav-pills:before,.nav-tabs:after,.nav-pills:after{display:table;content:""}.nav-tabs:after,.nav-pills:after{clear:both}.nav-tabs>li,.nav-pills>li{float:left}.nav-tabs>li>a,.nav-pills>li>a{padding-right:12px;padding-left:12px;margin-right:2px;line-height:14px}.nav-tabs{border-bottom:1px solid #ddd}.nav-tabs>li{margin-bottom:-1px}.nav-tabs>li>a{padding-top:8px;padding-bottom:8px;line-height:18px;border:1px solid transparent;-webkit-border-radius:4px 4px 0 0;-moz-border-radius:4px 4px 0 0;border-radius:4px 4px 0 0}.nav-tabs>li>a:hover{border-color:#eee #eee #ddd}.nav-tabs>.active>a,.nav-tabs>.active>a:hover{color:#555;cursor:default;background-color:#fff;border:1px solid #ddd;border-bottom-color:transparent}.nav-pills>li>a{padding-top:8px;padding-bottom:8px;margin-top:2px;margin-bottom:2px;-webkit-border-radius:5px;-moz-border-radius:5px;border-radius:5px}.nav-pills>.active>a,.nav-pills>.active>a:hover{color:#fff;background-color:#08c}.nav-stacked>li{float:none}.nav-stacked>li>a{margin-right:0}.nav-tabs.nav-stacked{border-bottom:0}.nav-tabs.nav-stacked>li>a{border:1px solid #ddd;-webkit-border-radius:0;-moz-border-radius:0;border-radius:0}.nav-tabs.nav-stacked>li:first-child>a{-webkit-border-radius:4px 4px 0 0;-moz-border-radius:4px 4px 0 0;border-radius:4px 4px 0 0}.nav-tabs.nav-stacked>li:last-child>a{-webkit-border-radius:0 0 4px 4px;-moz-border-radius:0 0 4px 4px;border-radius:0 0 4px 4px}.nav-tabs.nav-stacked>li>a:hover{z-index:2;border-color:#ddd}.nav-pills.nav-stacked>li>a{margin-bottom:3px}.nav-pills.nav-stacked>li:last-child>a{margin-bottom:1px}.nav-tabs .dropdown-menu{-webkit-border-radius:0 0 5px 5px;-moz-border-radius:0 0 5px 5px;border-radius:0 0 5px 5px}.nav-pills .dropdown-menu{-webkit-border-radius:4px;-moz-border-radius:4px;border-radius:4px}.nav-tabs .dropdown-toggle .caret,.nav-pills .dropdown-toggle .caret{margin-top:6px;border-top-color:#08c;border-bottom-color:#08c}.nav-tabs .dropdown-toggle:hover .caret,.nav-pills .dropdown-toggle:hover .caret{border-top-color:#005580;border-bottom-color:#005580}.nav-tabs .active .dropdown-toggle .caret,.nav-pills .active .dropdown-toggle .caret{border-top-color:#333;border-bottom-color:#333}.nav>.dropdown.active>a:hover{color:#000;cursor:pointer}.nav-tabs .open .dropdown-toggle,.nav-pills .open .dropdown-toggle,.nav>li.dropdown.open.active>a:hover{color:#fff;background-color:#999;border-color:#999}.nav li.dropdown.open .caret,.nav li.dropdown.open.active .caret,.nav li.dropdown.open a:hover .caret{border-top-color:#fff;border-bottom-color:#fff;opacity:1;filter:alpha(opacity=100)}.tabs-stacked .open>a:hover{border-color:#999}.tabbable{*zoom:1}.tabbable:before,.tabbable:after{display:table;content:""}.tabbable:after{clear:both}.tab-content{overflow:auto}.tabs-below>.nav-tabs,.tabs-right>.nav-tabs,.tabs-left>.nav-tabs{border-bottom:0}.tab-content>.tab-pane,.pill-content>.pill-pane{display:none}.tab-content>.active,.pill-content>.active{display:block}.tabs-below>.nav-tabs{border-top:1px solid #ddd}.tabs-below>.nav-tabs>li{margin-top:-1px;margin-bottom:0}.tabs-below>.nav-tabs>li>a{-webkit-border-radius:0 0 4px 4px;-moz-border-radius:0 0 4px 4px;border-radius:0 0 4px 4px}.tabs-below>.nav-tabs>li>a:hover{border-top-color:#ddd;border-bottom-color:transparent}.tabs-below>.nav-tabs>.active>a,.tabs-below>.nav-tabs>.active>a:hover{border-color:transparent #ddd #ddd #ddd}.tabs-left>.nav-tabs>li,.tabs-right>.nav-tabs>li{float:none}.tabs-left>.nav-tabs>li>a,.tabs-right>.nav-tabs>li>a{min-width:74px;margin-right:0;margin-bottom:3px}.tabs-left>.nav-tabs{float:left;margin-right:19px;border-right:1px solid #ddd}.tabs-left>.nav-tabs>li>a{margin-right:-1px;-webkit-border-radius:4px 0 0 4px;-moz-border-radius:4px 0 0 4px;border-radius:4px 0 0 4px}.tabs-left>.nav-tabs>li>a:hover{border-color:#eee #ddd #eee #eee}.tabs-left>.nav-tabs .active>a,.tabs-left>.nav-tabs .active>a:hover{border-color:#ddd transparent #ddd #ddd;*border-right-color:#fff}.tabs-right>.nav-tabs{float:right;margin-left:19px;border-left:1px solid #ddd}.tabs-right>.nav-tabs>li>a{margin-left:-1px;-webkit-border-radius:0 4px 4px 0;-moz-border-radius:0 4px 4px 0;border-radius:0 4px 4px 0}.tabs-right>.nav-tabs>li>a:hover{border-color:#eee #eee #eee #ddd}.tabs-right>.nav-tabs .active>a,.tabs-right>.nav-tabs .active>a:hover{border-color:#ddd #ddd #ddd transparent;*border-left-color:#fff}.navbar{*position:relative;*z-index:2;margin-bottom:18px;overflow:visible}.navbar-inner{min-height:40px;padding-right:20px;padding-left:20px;background-color:#2153a5;background-image:-moz-linear-gradient(top,#2b5dad,#13459a);background-image:-ms-linear-gradient(top,#2b5dad,#13459a);background-image:-webkit-gradient(linear,0 0,0 100%,from(#2b5dad),to(#13459a));background-image:-webkit-linear-gradient(top,#2b5dad,#13459a);background-image:-o-linear-gradient(top,#2b5dad,#13459a);background-image:linear-gradient(top,#2b5dad,#13459a);background-repeat:repeat-x;-webkit-border-radius:4px;-moz-border-radius:4px;border-radius:4px;filter:progid:dximagetransform.microsoft.gradient(startColorstr='#2b5dad',endColorstr='#13459a',GradientType=0);-webkit-box-shadow:0 1px 3px rgba(0,0,0,0.25),inset 0 -1px 0 rgba(0,0,0,0.1);-moz-box-shadow:0 1px 3px rgba(0,0,0,0.25),inset 0 -1px 0 rgba(0,0,0,0.1);box-shadow:0 1px 3px rgba(0,0,0,0.25),inset 0 -1px 0 rgba(0,0,0,0.1)}.navbar .container{width:auto}.nav-collapse.collapse{height:auto}.navbar{color:#ddd}.navbar .brand:hover{text-decoration:none}.navbar .brand{display:block;float:left;padding:8px 20px 12px;margin-left:-20px;font-size:20px;font-weight:200;line-height:1;color:#ddd}.navbar .navbar-text{margin-bottom:0;line-height:40px}.navbar .navbar-link{color:#ddd}.navbar .navbar-link:hover{color:#fff}.navbar .btn,.navbar .btn-group{margin-top:5px}.navbar .btn-group .btn{margin:0}.navbar-form{margin-bottom:0;*zoom:1}.navbar-form:before,.navbar-form:after{display:table;content:""}.navbar-form:after{clear:both}.navbar-form input,.navbar-form select,.navbar-form .radio,.navbar-form .checkbox{margin-top:5px}.navbar-form input,.navbar-form select{display:inline-block;margin-bottom:0}.navbar-form input[type="image"],.navbar-form input[type="checkbox"],.navbar-form input[type="radio"]{margin-top:3px}.navbar-form .input-append,.navbar-form .input-prepend{margin-top:6px;white-space:nowrap}.navbar-form .input-append input,.navbar-form .input-prepend input{margin-top:0}.navbar-search{position:relative;float:left;margin-top:6px;margin-bottom:0}.navbar-search .search-query{padding:4px 9px;font-family:"Helvetica Neue",Helvetica,Arial,sans-serif;font-size:13px;font-weight:normal;line-height:1;color:#fff;background-color:#4581e8;border:1px solid #103b83;-webkit-box-shadow:inset 0 1px 2px rgba(0,0,0,0.1),0 1px 0 rgba(255,255,255,0.15);-moz-box-shadow:inset 0 1px 2px rgba(0,0,0,0.1),0 1px 0 rgba(255,255,255,0.15);box-shadow:inset 0 1px 2px rgba(0,0,0,0.1),0 1px 0 rgba(255,255,255,0.15);-webkit-transition:none;-moz-transition:none;-ms-transition:none;-o-transition:none;transition:none}.navbar-search .search-query:-moz-placeholder{color:#ccc}.navbar-search .search-query:-ms-input-placeholder{color:#ccc}.navbar-search .search-query::-webkit-input-placeholder{color:#ccc}.navbar-search .search-query:focus,.navbar-search .search-query.focused{padding:5px 10px;color:#333;text-shadow:0 1px 0 #fff;background-color:#fff;border:0;outline:0;-webkit-box-shadow:0 0 3px rgba(0,0,0,0.15);-moz-box-shadow:0 0 3px rgba(0,0,0,0.15);box-shadow:0 0 3px rgba(0,0,0,0.15)}.navbar-fixed-top,.navbar-fixed-bottom{position:fixed;right:0;left:0;z-index:1030;margin-bottom:0}.navbar-fixed-top .navbar-inner,.navbar-fixed-bottom .navbar-inner{padding-right:0;padding-left:0;-webkit-border-radius:0;-moz-border-radius:0;border-radius:0}.navbar-fixed-top .container,.navbar-fixed-bottom .container{width:940px}.navbar-fixed-top{top:0}.navbar-fixed-bottom{bottom:0}.navbar .nav{position:relative;left:0;display:block;float:left;margin:0 10px 0 0}.navbar .nav.pull-right{float:right}.navbar .nav>li{display:block;float:left}.navbar .nav>li>a{float:none;padding:9px 10px 11px;line-height:19px;color:#ddd;text-decoration:none;text-shadow:0 -1px 0 rgba(0,0,0,0.25)}.navbar .btn{display:inline-block;padding:4px 10px 4px;margin:5px 5px 6px;line-height:18px}.navbar .btn-group{padding:5px 5px 6px;margin:0}.navbar .nav>li>a:hover{color:#fff;text-decoration:none;background-color:transparent}.navbar .nav .active>a,.navbar .nav .active>a:hover{color:#fff;text-decoration:none;background-color:#13459a}.navbar .divider-vertical{width:1px;height:40px;margin:0 9px;overflow:hidden;background-color:#13459a;border-right:1px solid #2b5dad}.navbar .nav.pull-right{margin-right:0;margin-left:10px}.navbar .btn-navbar{display:none;float:right;padding:7px 10px;margin-right:5px;margin-left:5px;background-color:#2153a5;*background-color:#13459a;background-image:-ms-linear-gradient(top,#2b5dad,#13459a);background-image:-webkit-gradient(linear,0 0,0 100%,from(#2b5dad),to(#13459a));background-image:-webkit-linear-gradient(top,#2b5dad,#13459a);background-image:-o-linear-gradient(top,#2b5dad,#13459a);background-image:linear-gradient(top,#2b5dad,#13459a);background-image:-moz-linear-gradient(top,#2b5dad,#13459a);background-repeat:repeat-x;border-color:#13459a #13459a #0b2656;border-color:rgba(0,0,0,0.1) rgba(0,0,0,0.1) rgba(0,0,0,0.25);filter:progid:dximagetransform.microsoft.gradient(startColorstr='#2b5dad',endColorstr='#13459a',GradientType=0);filter:progid:dximagetransform.microsoft.gradient(enabled=false);-webkit-box-shadow:inset 0 1px 0 rgba(255,255,255,0.1),0 1px 0 rgba(255,255,255,0.075);-moz-box-shadow:inset 0 1px 0 rgba(255,255,255,0.1),0 1px 0 rgba(255,255,255,0.075);box-shadow:inset 0 1px 0 rgba(255,255,255,0.1),0 1px 0 rgba(255,255,255,0.075)}.navbar .btn-navbar:hover,.navbar .btn-navbar:active,.navbar .btn-navbar.active,.navbar .btn-navbar.disabled,.navbar .btn-navbar[disabled]{background-color:#13459a;*background-color:#103b83}.navbar .btn-navbar:active,.navbar .btn-navbar.active{background-color:#0d316d \9}.navbar .btn-navbar .icon-bar{display:block;width:18px;height:2px;background-color:#f5f5f5;-webkit-border-radius:1px;-moz-border-radius:1px;border-radius:1px;-webkit-box-shadow:0 1px 0 rgba(0,0,0,0.25);-moz-box-shadow:0 1px 0 rgba(0,0,0,0.25);box-shadow:0 1px 0 rgba(0,0,0,0.25)}.btn-navbar .icon-bar+.icon-bar{margin-top:3px}.navbar .dropdown-menu:before{position:absolute;top:-7px;left:9px;display:inline-block;border-right:7px solid transparent;border-bottom:7px solid #ccc;border-left:7px solid transparent;border-bottom-color:rgba(0,0,0,0.2);content:''}.navbar .dropdown-menu:after{position:absolute;top:-6px;left:10px;display:inline-block;border-right:6px solid transparent;border-bottom:6px solid #fff;border-left:6px solid transparent;content:''}.navbar-fixed-bottom .dropdown-menu:before{top:auto;bottom:-7px;border-top:7px solid #ccc;border-bottom:0;border-top-color:rgba(0,0,0,0.2)}.navbar-fixed-bottom .dropdown-menu:after{top:auto;bottom:-6px;border-top:6px solid #fff;border-bottom:0}.navbar .nav li.dropdown .dropdown-toggle .caret,.navbar .nav li.dropdown.open .caret{border-top-color:#fff;border-bottom-color:#fff}.navbar .nav li.dropdown.active .caret{opacity:1;filter:alpha(opacity=100)}.navbar .nav li.dropdown.open>.dropdown-toggle,.navbar .nav li.dropdown.active>.dropdown-toggle,.navbar .nav li.dropdown.open.active>.dropdown-toggle{background-color:transparent}.navbar .nav li.dropdown.active>.dropdown-toggle:hover{color:#fff}.navbar .pull-right .dropdown-menu,.navbar .dropdown-menu.pull-right{right:0;left:auto}.navbar .pull-right .dropdown-menu:before,.navbar .dropdown-menu.pull-right:before{right:12px;left:auto}.navbar .pull-right .dropdown-menu:after,.navbar .dropdown-menu.pull-right:after{right:13px;left:auto}.breadcrumb{padding:7px 14px;margin:0 0 18px;list-style:none;background-color:#fbfbfb;background-image:-moz-linear-gradient(top,#fff,#f5f5f5);background-image:-ms-linear-gradient(top,#fff,#f5f5f5);background-image:-webkit-gradient(linear,0 0,0 100%,from(#fff),to(#f5f5f5));background-image:-webkit-linear-gradient(top,#fff,#f5f5f5);background-image:-o-linear-gradient(top,#fff,#f5f5f5);background-image:linear-gradient(top,#fff,#f5f5f5);background-repeat:repeat-x;border:1px solid #ddd;-webkit-border-radius:3px;-moz-border-radius:3px;border-radius:3px;filter:progid:dximagetransform.microsoft.gradient(startColorstr='#ffffff',endColorstr='#f5f5f5',GradientType=0);-webkit-box-shadow:inset 0 1px 0 #fff;-moz-box-shadow:inset 0 1px 0 #fff;box-shadow:inset 0 1px 0 #fff}.breadcrumb li{display:inline-block;*display:inline;text-shadow:0 1px 0 #fff;*zoom:1}.breadcrumb .divider{padding:0 5px;color:#999}.breadcrumb .active a{color:#333}.pagination{height:36px;margin:18px 0}.pagination ul{display:inline-block;*display:inline;margin-bottom:0;margin-left:0;-webkit-border-radius:3px;-moz-border-radius:3px;border-radius:3px;*zoom:1;-webkit-box-shadow:0 1px 2px rgba(0,0,0,0.05);-moz-box-shadow:0 1px 2px rgba(0,0,0,0.05);box-shadow:0 1px 2px rgba(0,0,0,0.05)}.pagination li{display:inline}.pagination a{float:left;padding:0 14px;line-height:34px;text-decoration:none;border:1px solid #ddd;border-left-width:0}.pagination a:hover,.pagination .active a{background-color:#f5f5f5}.pagination .active a{color:#999;cursor:default}.pagination .disabled span,.pagination .disabled a,.pagination .disabled a:hover{color:#999;cursor:default;background-color:transparent}.pagination li:first-child a{border-left-width:1px;-webkit-border-radius:3px 0 0 3px;-moz-border-radius:3px 0 0 3px;border-radius:3px 0 0 3px}.pagination li:last-child a{-webkit-border-radius:0 3px 3px 0;-moz-border-radius:0 3px 3px 0;border-radius:0 3px 3px 0}.pagination-centered{text-align:center}.pagination-right{text-align:right}.pager{margin-bottom:18px;margin-left:0;text-align:center;list-style:none;*zoom:1}.pager:before,.pager:after{display:table;content:""}.pager:after{clear:both}.pager li{display:inline}.pager a{display:inline-block;padding:5px 14px;background-color:#fff;border:1px solid #ddd;-webkit-border-radius:15px;-moz-border-radius:15px;border-radius:15px}.pager a:hover{text-decoration:none;background-color:#f5f5f5}.pager .next a{float:right}.pager .previous a{float:left}.pager .disabled a,.pager .disabled a:hover{color:#999;cursor:default;background-color:#fff}.modal-open .dropdown-menu{z-index:2050}.modal-open .dropdown.open{*z-index:2050}.modal-open .popover{z-index:2060}.modal-open .tooltip{z-index:2070}.modal-backdrop{position:fixed;top:0;right:0;bottom:0;left:0;z-index:1040;background-color:#000}.modal-backdrop.fade{opacity:0}.modal-backdrop,.modal-backdrop.fade.in{opacity:.8;filter:alpha(opacity=80)}.modal{position:fixed;top:50%;left:50%;z-index:1050;width:560px;margin:-250px 0 0 -280px;overflow:auto;background-color:#fff;border:1px solid #999;border:1px solid rgba(0,0,0,0.3);*border:1px solid #999;-webkit-border-radius:6px;-moz-border-radius:6px;border-radius:6px;-webkit-box-shadow:0 3px 7px rgba(0,0,0,0.3);-moz-box-shadow:0 3px 7px rgba(0,0,0,0.3);box-shadow:0 3px 7px rgba(0,0,0,0.3);-webkit-background-clip:padding-box;-moz-background-clip:padding-box;background-clip:padding-box}.modal.fade{top:-25%;-webkit-transition:opacity .3s linear,top .3s ease-out;-moz-transition:opacity .3s linear,top .3s ease-out;-ms-transition:opacity .3s linear,top .3s ease-out;-o-transition:opacity .3s linear,top .3s ease-out;transition:opacity .3s linear,top .3s ease-out}.modal.fade.in{top:50%}.modal-header{padding:9px 15px;border-bottom:1px solid #eee}.modal-header .close{margin-top:2px}.modal-body{max-height:400px;padding:15px;overflow-y:auto}.modal-form{margin-bottom:0}.modal-footer{padding:14px 15px 15px;margin-bottom:0;text-align:right;background-color:#f5f5f5;border-top:1px solid #ddd;-webkit-border-radius:0 0 6px 6px;-moz-border-radius:0 0 6px 6px;border-radius:0 0 6px 6px;*zoom:1;-webkit-box-shadow:inset 0 1px 0 #fff;-moz-box-shadow:inset 0 1px 0 #fff;box-shadow:inset 0 1px 0 #fff}.modal-footer:before,.modal-footer:after{display:table;content:""}.modal-footer:after{clear:both}.modal-footer .btn+.btn{margin-bottom:0;margin-left:5px}.modal-footer .btn-group .btn+.btn{margin-left:-1px}.tooltip{position:absolute;z-index:1020;display:block;padding:5px;font-size:11px;opacity:0;filter:alpha(opacity=0);visibility:visible}.tooltip.in{opacity:.8;filter:alpha(opacity=80)}.tooltip.top{margin-top:-2px}.tooltip.right{margin-left:2px}.tooltip.bottom{margin-top:2px}.tooltip.left{margin-left:-2px}.tooltip.top .tooltip-arrow{bottom:0;left:50%;margin-left:-5px;border-top:5px solid #000;border-right:5px solid transparent;border-left:5px solid transparent}.tooltip.left .tooltip-arrow{top:50%;right:0;margin-top:-5px;border-top:5px solid transparent;border-bottom:5px solid transparent;border-left:5px solid #000}.tooltip.bottom .tooltip-arrow{top:0;left:50%;margin-left:-5px;border-right:5px solid transparent;border-bottom:5px solid #000;border-left:5px solid transparent}.tooltip.right .tooltip-arrow{top:50%;left:0;margin-top:-5px;border-top:5px solid transparent;border-right:5px solid #000;border-bottom:5px solid transparent}.tooltip-inner{max-width:200px;padding:3px 8px;color:#fff;text-align:center;text-decoration:none;background-color:#000;-webkit-border-radius:4px;-moz-border-radius:4px;border-radius:4px}.tooltip-arrow{position:absolute;width:0;height:0}.popover{position:absolute;top:0;left:0;z-index:1010;display:none;padding:5px}.popover.top{margin-top:-5px}.popover.right{margin-left:5px}.popover.bottom{margin-top:5px}.popover.left{margin-left:-5px}.popover.top .arrow{bottom:0;left:50%;margin-left:-5px;border-top:5px solid #000;border-right:5px solid transparent;border-left:5px solid transparent}.popover.right .arrow{top:50%;left:0;margin-top:-5px;border-top:5px solid transparent;border-right:5px solid #000;border-bottom:5px solid transparent}.popover.bottom .arrow{top:0;left:50%;margin-left:-5px;border-right:5px solid transparent;border-bottom:5px solid #000;border-left:5px solid transparent}.popover.left .arrow{top:50%;right:0;margin-top:-5px;border-top:5px solid transparent;border-bottom:5px solid transparent;border-left:5px solid #000}.popover .arrow{position:absolute;width:0;height:0}.popover-inner{width:280px;padding:3px;overflow:hidden;background:#000;background:rgba(0,0,0,0.8);-webkit-border-radius:6px;-moz-border-radius:6px;border-radius:6px;-webkit-box-shadow:0 3px 7px rgba(0,0,0,0.3);-moz-box-shadow:0 3px 7px rgba(0,0,0,0.3);box-shadow:0 3px 7px rgba(0,0,0,0.3)}.popover-title{padding:9px 15px;line-height:1;background-color:#f5f5f5;border-bottom:1px solid #eee;-webkit-border-radius:3px 3px 0 0;-moz-border-radius:3px 3px 0 0;border-radius:3px 3px 0 0}.popover-content{padding:14px;background-color:#fff;-webkit-border-radius:0 0 3px 3px;-moz-border-radius:0 0 3px 3px;border-radius:0 0 3px 3px;-webkit-background-clip:padding-box;-moz-background-clip:padding-box;background-clip:padding-box}.popover-content p,.popover-content ul,.popover-content ol{margin-bottom:0}.thumbnails{margin-left:-20px;list-style:none;*zoom:1}.thumbnails:before,.thumbnails:after{display:table;content:""}.thumbnails:after{clear:both}.row-fluid .thumbnails{margin-left:0}.thumbnails>li{float:left;margin-bottom:18px;margin-left:20px}.thumbnail{display:block;padding:4px;line-height:1;border:1px solid #ddd;-webkit-border-radius:4px;-moz-border-radius:4px;border-radius:4px;-webkit-box-shadow:0 1px 1px rgba(0,0,0,0.075);-moz-box-shadow:0 1px 1px rgba(0,0,0,0.075);box-shadow:0 1px 1px rgba(0,0,0,0.075)}a.thumbnail:hover{border-color:#08c;-webkit-box-shadow:0 1px 4px rgba(0,105,214,0.25);-moz-box-shadow:0 1px 4px rgba(0,105,214,0.25);box-shadow:0 1px 4px rgba(0,105,214,0.25)}.thumbnail>img{display:block;max-width:100%;margin-right:auto;margin-left:auto}.thumbnail .caption{padding:9px}.label,.badge{font-size:10.998px;font-weight:bold;line-height:14px;color:#fff;text-shadow:0 -1px 0 rgba(0,0,0,0.25);white-space:nowrap;vertical-align:baseline;background-color:#999}.label{padding:1px 4px 2px;-webkit-border-radius:3px;-moz-border-radius:3px;border-radius:3px}.badge{padding:1px 9px 2px;-webkit-border-radius:9px;-moz-border-radius:9px;border-radius:9px}a.label:hover,a.badge:hover{color:#fff;text-decoration:none;cursor:pointer}.label-important,.badge-important{background-color:#b94a48}.label-important[href],.badge-important[href]{background-color:#953b39}.label-warning,.badge-warning{background-color:#f89406}.label-warning[href],.badge-warning[href]{background-color:#c67605}.label-success,.badge-success{background-color:#468847}.label-success[href],.badge-success[href]{background-color:#356635}.label-info,.badge-info{background-color:#3a87ad}.label-info[href],.badge-info[href]{background-color:#2d6987}.label-inverse,.badge-inverse{background-color:#333}.label-inverse[href],.badge-inverse[href]{background-color:#1a1a1a}@-webkit-keyframes progress-bar-stripes{from{background-position:40px 0}to{background-position:0 0}}@-moz-keyframes progress-bar-stripes{from{background-position:40px 0}to{background-position:0 0}}@-ms-keyframes progress-bar-stripes{from{background-position:40px 0}to{background-position:0 0}}@-o-keyframes progress-bar-stripes{from{background-position:0 0}to{background-position:40px 0}}@keyframes progress-bar-stripes{from{background-position:40px 0}to{background-position:0 0}}.progress{height:18px;margin-bottom:18px;overflow:hidden;background-color:#f7f7f7;background-image:-moz-linear-gradient(top,#f5f5f5,#f9f9f9);background-image:-ms-linear-gradient(top,#f5f5f5,#f9f9f9);background-image:-webkit-gradient(linear,0 0,0 100%,from(#f5f5f5),to(#f9f9f9));background-image:-webkit-linear-gradient(top,#f5f5f5,#f9f9f9);background-image:-o-linear-gradient(top,#f5f5f5,#f9f9f9);background-image:linear-gradient(top,#f5f5f5,#f9f9f9);background-repeat:repeat-x;-webkit-border-radius:4px;-moz-border-radius:4px;border-radius:4px;filter:progid:dximagetransform.microsoft.gradient(startColorstr='#f5f5f5',endColorstr='#f9f9f9',GradientType=0);-webkit-box-shadow:inset 0 1px 2px rgba(0,0,0,0.1);-moz-box-shadow:inset 0 1px 2px rgba(0,0,0,0.1);box-shadow:inset 0 1px 2px rgba(0,0,0,0.1)}.progress .bar{width:0;height:18px;font-size:12px;color:#fff;text-align:center;text-shadow:0 -1px 0 rgba(0,0,0,0.25);background-color:#0e90d2;background-image:-moz-linear-gradient(top,#149bdf,#0480be);background-image:-webkit-gradient(linear,0 0,0 100%,from(#149bdf),to(#0480be));background-image:-webkit-linear-gradient(top,#149bdf,#0480be);background-image:-o-linear-gradient(top,#149bdf,#0480be);background-image:linear-gradient(top,#149bdf,#0480be);background-image:-ms-linear-gradient(top,#149bdf,#0480be);background-repeat:repeat-x;filter:progid:dximagetransform.microsoft.gradient(startColorstr='#149bdf',endColorstr='#0480be',GradientType=0);-webkit-box-shadow:inset 0 -1px 0 rgba(0,0,0,0.15);-moz-box-shadow:inset 0 -1px 0 rgba(0,0,0,0.15);box-shadow:inset 0 -1px 0 rgba(0,0,0,0.15);-webkit-box-sizing:border-box;-moz-box-sizing:border-box;-ms-box-sizing:border-box;box-sizing:border-box;-webkit-transition:width .6s ease;-moz-transition:width .6s ease;-ms-transition:width .6s ease;-o-transition:width .6s ease;transition:width .6s ease}.progress-striped .bar{background-color:#149bdf;background-image:-o-linear-gradient(-45deg,rgba(255,255,255,0.15) 25%,transparent 25%,transparent 50%,rgba(255,255,255,0.15) 50%,rgba(255,255,255,0.15) 75%,transparent 75%,transparent);background-image:-webkit-linear-gradient(-45deg,rgba(255,255,255,0.15) 25%,transparent 25%,transparent 50%,rgba(255,255,255,0.15) 50%,rgba(255,255,255,0.15) 75%,transparent 75%,transparent);background-image:-moz-linear-gradient(-45deg,rgba(255,255,255,0.15) 25%,transparent 25%,transparent 50%,rgba(255,255,255,0.15) 50%,rgba(255,255,255,0.15) 75%,transparent 75%,transparent);background-image:-ms-linear-gradient(-45deg,rgba(255,255,255,0.15) 25%,transparent 25%,transparent 50%,rgba(255,255,255,0.15) 50%,rgba(255,255,255,0.15) 75%,transparent 75%,transparent);background-image:-webkit-gradient(linear,0 100%,100% 0,color-stop(0.25,rgba(255,255,255,0.15)),color-stop(0.25,transparent),color-stop(0.5,transparent),color-stop(0.5,rgba(255,255,255,0.15)),color-stop(0.75,rgba(255,255,255,0.15)),color-stop(0.75,transparent),to(transparent));background-image:linear-gradient(-45deg,rgba(255,255,255,0.15) 25%,transparent 25%,transparent 50%,rgba(255,255,255,0.15) 50%,rgba(255,255,255,0.15) 75%,transparent 75%,transparent);-webkit-background-size:40px 40px;-moz-background-size:40px 40px;-o-background-size:40px 40px;background-size:40px 40px}.progress.active .bar{-webkit-animation:progress-bar-stripes 2s linear infinite;-moz-animation:progress-bar-stripes 2s linear infinite;-ms-animation:progress-bar-stripes 2s linear infinite;-o-animation:progress-bar-stripes 2s linear infinite;animation:progress-bar-stripes 2s linear infinite}.progress-danger .bar{background-color:#dd514c;background-image:-moz-linear-gradient(top,#ee5f5b,#c43c35);background-image:-ms-linear-gradient(top,#ee5f5b,#c43c35);background-image:-webkit-gradient(linear,0 0,0 100%,from(#ee5f5b),to(#c43c35));background-image:-webkit-linear-gradient(top,#ee5f5b,#c43c35);background-image:-o-linear-gradient(top,#ee5f5b,#c43c35);background-image:linear-gradient(top,#ee5f5b,#c43c35);background-repeat:repeat-x;filter:progid:dximagetransform.microsoft.gradient(startColorstr='#ee5f5b',endColorstr='#c43c35',GradientType=0)}.progress-danger.progress-striped .bar{background-color:#ee5f5b;background-image:-webkit-gradient(linear,0 100%,100% 0,color-stop(0.25,rgba(255,255,255,0.15)),color-stop(0.25,transparent),color-stop(0.5,transparent),color-stop(0.5,rgba(255,255,255,0.15)),color-stop(0.75,rgba(255,255,255,0.15)),color-stop(0.75,transparent),to(transparent));background-image:-webkit-linear-gradient(-45deg,rgba(255,255,255,0.15) 25%,transparent 25%,transparent 50%,rgba(255,255,255,0.15) 50%,rgba(255,255,255,0.15) 75%,transparent 75%,transparent);background-image:-moz-linear-gradient(-45deg,rgba(255,255,255,0.15) 25%,transparent 25%,transparent 50%,rgba(255,255,255,0.15) 50%,rgba(255,255,255,0.15) 75%,transparent 75%,transparent);background-image:-ms-linear-gradient(-45deg,rgba(255,255,255,0.15) 25%,transparent 25%,transparent 50%,rgba(255,255,255,0.15) 50%,rgba(255,255,255,0.15) 75%,transparent 75%,transparent);background-image:-o-linear-gradient(-45deg,rgba(255,255,255,0.15) 25%,transparent 25%,transparent 50%,rgba(255,255,255,0.15) 50%,rgba(255,255,255,0.15) 75%,transparent 75%,transparent);background-image:linear-gradient(-45deg,rgba(255,255,255,0.15) 25%,transparent 25%,transparent 50%,rgba(255,255,255,0.15) 50%,rgba(255,255,255,0.15) 75%,transparent 75%,transparent)}.progress-success .bar{background-color:#5eb95e;background-image:-moz-linear-gradient(top,#62c462,#57a957);background-image:-ms-linear-gradient(top,#62c462,#57a957);background-image:-webkit-gradient(linear,0 0,0 100%,from(#62c462),to(#57a957));background-image:-webkit-linear-gradient(top,#62c462,#57a957);background-image:-o-linear-gradient(top,#62c462,#57a957);background-image:linear-gradient(top,#62c462,#57a957);background-repeat:repeat-x;filter:progid:dximagetransform.microsoft.gradient(startColorstr='#62c462',endColorstr='#57a957',GradientType=0)}.progress-success.progress-striped .bar{background-color:#62c462;background-image:-webkit-gradient(linear,0 100%,100% 0,color-stop(0.25,rgba(255,255,255,0.15)),color-stop(0.25,transparent),color-stop(0.5,transparent),color-stop(0.5,rgba(255,255,255,0.15)),color-stop(0.75,rgba(255,255,255,0.15)),color-stop(0.75,transparent),to(transparent));background-image:-webkit-linear-gradient(-45deg,rgba(255,255,255,0.15) 25%,transparent 25%,transparent 50%,rgba(255,255,255,0.15) 50%,rgba(255,255,255,0.15) 75%,transparent 75%,transparent);background-image:-moz-linear-gradient(-45deg,rgba(255,255,255,0.15) 25%,transparent 25%,transparent 50%,rgba(255,255,255,0.15) 50%,rgba(255,255,255,0.15) 75%,transparent 75%,transparent);background-image:-ms-linear-gradient(-45deg,rgba(255,255,255,0.15) 25%,transparent 25%,transparent 50%,rgba(255,255,255,0.15) 50%,rgba(255,255,255,0.15) 75%,transparent 75%,transparent);background-image:-o-linear-gradient(-45deg,rgba(255,255,255,0.15) 25%,transparent 25%,transparent 50%,rgba(255,255,255,0.15) 50%,rgba(255,255,255,0.15) 75%,transparent 75%,transparent);background-image:linear-gradient(-45deg,rgba(255,255,255,0.15) 25%,transparent 25%,transparent 50%,rgba(255,255,255,0.15) 50%,rgba(255,255,255,0.15) 75%,transparent 75%,transparent)}.progress-info .bar{background-color:#4bb1cf;background-image:-moz-linear-gradient(top,#5bc0de,#339bb9);background-image:-ms-linear-gradient(top,#5bc0de,#339bb9);background-image:-webkit-gradient(linear,0 0,0 100%,from(#5bc0de),to(#339bb9));background-image:-webkit-linear-gradient(top,#5bc0de,#339bb9);background-image:-o-linear-gradient(top,#5bc0de,#339bb9);background-image:linear-gradient(top,#5bc0de,#339bb9);background-repeat:repeat-x;filter:progid:dximagetransform.microsoft.gradient(startColorstr='#5bc0de',endColorstr='#339bb9',GradientType=0)}.progress-info.progress-striped .bar{background-color:#5bc0de;background-image:-webkit-gradient(linear,0 100%,100% 0,color-stop(0.25,rgba(255,255,255,0.15)),color-stop(0.25,transparent),color-stop(0.5,transparent),color-stop(0.5,rgba(255,255,255,0.15)),color-stop(0.75,rgba(255,255,255,0.15)),color-stop(0.75,transparent),to(transparent));background-image:-webkit-linear-gradient(-45deg,rgba(255,255,255,0.15) 25%,transparent 25%,transparent 50%,rgba(255,255,255,0.15) 50%,rgba(255,255,255,0.15) 75%,transparent 75%,transparent);background-image:-moz-linear-gradient(-45deg,rgba(255,255,255,0.15) 25%,transparent 25%,transparent 50%,rgba(255,255,255,0.15) 50%,rgba(255,255,255,0.15) 75%,transparent 75%,transparent);background-image:-ms-linear-gradient(-45deg,rgba(255,255,255,0.15) 25%,transparent 25%,transparent 50%,rgba(255,255,255,0.15) 50%,rgba(255,255,255,0.15) 75%,transparent 75%,transparent);background-image:-o-linear-gradient(-45deg,rgba(255,255,255,0.15) 25%,transparent 25%,transparent 50%,rgba(255,255,255,0.15) 50%,rgba(255,255,255,0.15) 75%,transparent 75%,transparent);background-image:linear-gradient(-45deg,rgba(255,255,255,0.15) 25%,transparent 25%,transparent 50%,rgba(255,255,255,0.15) 50%,rgba(255,255,255,0.15) 75%,transparent 75%,transparent)}.progress-warning .bar{background-color:#faa732;background-image:-moz-linear-gradient(top,#fbb450,#f89406);background-image:-ms-linear-gradient(top,#fbb450,#f89406);background-image:-webkit-gradient(linear,0 0,0 100%,from(#fbb450),to(#f89406));background-image:-webkit-linear-gradient(top,#fbb450,#f89406);background-image:-o-linear-gradient(top,#fbb450,#f89406);background-image:linear-gradient(top,#fbb450,#f89406);background-repeat:repeat-x;filter:progid:dximagetransform.microsoft.gradient(startColorstr='#fbb450',endColorstr='#f89406',GradientType=0)}.progress-warning.progress-striped .bar{background-color:#fbb450;background-image:-webkit-gradient(linear,0 100%,100% 0,color-stop(0.25,rgba(255,255,255,0.15)),color-stop(0.25,transparent),color-stop(0.5,transparent),color-stop(0.5,rgba(255,255,255,0.15)),color-stop(0.75,rgba(255,255,255,0.15)),color-stop(0.75,transparent),to(transparent));background-image:-webkit-linear-gradient(-45deg,rgba(255,255,255,0.15) 25%,transparent 25%,transparent 50%,rgba(255,255,255,0.15) 50%,rgba(255,255,255,0.15) 75%,transparent 75%,transparent);background-image:-moz-linear-gradient(-45deg,rgba(255,255,255,0.15) 25%,transparent 25%,transparent 50%,rgba(255,255,255,0.15) 50%,rgba(255,255,255,0.15) 75%,transparent 75%,transparent);background-image:-ms-linear-gradient(-45deg,rgba(255,255,255,0.15) 25%,transparent 25%,transparent 50%,rgba(255,255,255,0.15) 50%,rgba(255,255,255,0.15) 75%,transparent 75%,transparent);background-image:-o-linear-gradient(-45deg,rgba(255,255,255,0.15) 25%,transparent 25%,transparent 50%,rgba(255,255,255,0.15) 50%,rgba(255,255,255,0.15) 75%,transparent 75%,transparent);background-image:linear-gradient(-45deg,rgba(255,255,255,0.15) 25%,transparent 25%,transparent 50%,rgba(255,255,255,0.15) 50%,rgba(255,255,255,0.15) 75%,transparent 75%,transparent)}.accordion{margin-bottom:18px}.accordion-group{margin-bottom:2px;border:1px solid #e5e5e5;-webkit-border-radius:4px;-moz-border-radius:4px;border-radius:4px}.accordion-heading{border-bottom:0}.accordion-heading .accordion-toggle{display:block;padding:8px 15px}.accordion-toggle{cursor:pointer}.accordion-inner{padding:9px 15px;border-top:1px solid #e5e5e5}.carousel{position:relative;margin-bottom:18px;line-height:1}.carousel-inner{position:relative;width:100%;overflow:hidden}.carousel .item{position:relative;display:none;-webkit-transition:.6s ease-in-out left;-moz-transition:.6s ease-in-out left;-ms-transition:.6s ease-in-out left;-o-transition:.6s ease-in-out left;transition:.6s ease-in-out left}.carousel .item>img{display:block;line-height:1}.carousel .active,.carousel .next,.carousel .prev{display:block}.carousel .active{left:0}.carousel .next,.carousel .prev{position:absolute;top:0;width:100%}.carousel .next{left:100%}.carousel .prev{left:-100%}.carousel .next.left,.carousel .prev.right{left:0}.carousel .active.left{left:-100%}.carousel .active.right{left:100%}.carousel-control{position:absolute;top:40%;left:15px;width:40px;height:40px;margin-top:-20px;font-size:60px;font-weight:100;line-height:30px;color:#fff;text-align:center;background:#222;border:3px solid #fff;-webkit-border-radius:23px;-moz-border-radius:23px;border-radius:23px;opacity:.5;filter:alpha(opacity=50)}.carousel-control.right{right:15px;left:auto}.carousel-control:hover{color:#fff;text-decoration:none;opacity:.9;filter:alpha(opacity=90)}.carousel-caption{position:absolute;right:0;bottom:0;left:0;padding:10px 15px 5px;background:#333;background:rgba(0,0,0,0.75)}.carousel-caption h4,.carousel-caption p{color:#fff}.hero-unit{padding:60px;margin-bottom:30px;background-color:#eee;-webkit-border-radius:6px;-moz-border-radius:6px;border-radius:6px}.hero-unit h1{margin-bottom:0;font-size:60px;line-height:1;letter-spacing:-1px;color:inherit}.hero-unit p{font-size:18px;font-weight:200;line-height:27px;color:inherit}.pull-right{float:right}.pull-left{float:left}.hide{display:none}.show{display:block}.invisible{visibility:hidden}.clearfix{*zoom:1}.clearfix:before,.clearfix:after{display:table;content:""}.clearfix:after{clear:both}.hide-text{font:0/0 a;color:transparent;text-shadow:none;background-color:transparent;border:0}.input-block-level{display:block;width:100%;min-height:28px;-webkit-box-sizing:border-box;-moz-box-sizing:border-box;-ms-box-sizing:border-box;box-sizing:border-box}.hidden{display:none;visibility:hidden}.visible-phone{display:none!important}.visible-tablet{display:none!important}.hidden-desktop{display:none!important}@media(max-width:767px){.visible-phone{display:inherit!important}.hidden-phone{display:none!important}.hidden-desktop{display:inherit!important}.visible-desktop{display:none!important}}@media(min-width:768px) and (max-width:979px){.visible-tablet{display:inherit!important}.hidden-tablet{display:none!important}.hidden-desktop{display:inherit!important}.visible-desktop{display:none!important}}@media(max-width:480px){.nav-collapse{-webkit-transform:translate3d(0,0,0)}.page-header h1 small{display:block;line-height:18px}input[type="checkbox"],input[type="radio"]{border:1px solid #ccc}.form-horizontal .control-group>label{float:none;width:auto;padding-top:0;text-align:left}.form-horizontal .controls{margin-left:0}.form-horizontal .control-list{padding-top:0}.form-horizontal .form-actions{padding-right:10px;padding-left:10px}.modal{position:absolute;top:10px;right:10px;left:10px;width:auto;margin:0}.modal.fade.in{top:auto}.modal-header .close{padding:10px;margin:-10px}.carousel-caption{position:static}}@media(max-width:767px){body{padding-right:20px;padding-left:20px}.navbar-fixed-top,.navbar-fixed-bottom{margin-right:-20px;margin-left:-20px}.container-fluid{padding:0}.dl-horizontal dt{float:none;width:auto;clear:none;text-align:left}.dl-horizontal dd{margin-left:0}.container{width:auto}.row-fluid{width:100%}.row,.thumbnails{margin-left:0}[class*="span"],.row-fluid [class*="span"]{display:block;float:none;width:auto;margin-left:0}.input-large,.input-xlarge,.input-xxlarge,input[class*="span"],select[class*="span"],textarea[class*="span"],.uneditable-input{display:block;width:100%;min-height:28px;-webkit-box-sizing:border-box;-moz-box-sizing:border-box;-ms-box-sizing:border-box;box-sizing:border-box}.input-prepend input,.input-append input,.input-prepend input[class*="span"],.input-append input[class*="span"]{display:inline-block;width:auto}}@media(min-width:768px) and (max-width:979px){.row{margin-left:-20px;*zoom:1}.row:before,.row:after{display:table;content:""}.row:after{clear:both}[class*="span"]{float:left;margin-left:20px}.container,.navbar-fixed-top .container,.navbar-fixed-bottom .container{width:724px}.span12{width:724px}.span11{width:662px}.span10{width:600px}.span9{width:538px}.span8{width:476px}.span7{width:414px}.span6{width:352px}.span5{width:290px}.span4{width:228px}.span3{width:166px}.span2{width:104px}.span1{width:42px}.offset12{margin-left:764px}.offset11{margin-left:702px}.offset10{margin-left:640px}.offset9{margin-left:578px}.offset8{margin-left:516px}.offset7{margin-left:454px}.offset6{margin-left:392px}.offset5{margin-left:330px}.offset4{margin-left:268px}.offset3{margin-left:206px}.offset2{margin-left:144px}.offset1{margin-left:82px}.row-fluid{width:100%;*zoom:1}.row-fluid:before,.row-fluid:after{display:table;content:""}.row-fluid:after{clear:both}.row-fluid [class*="span"]{display:block;float:left;width:100%;min-height:28px;margin-left:2.762430939%;*margin-left:2.709239449638298%;-webkit-box-sizing:border-box;-moz-box-sizing:border-box;-ms-box-sizing:border-box;box-sizing:border-box}.row-fluid [class*="span"]:first-child{margin-left:0}.row-fluid .span12{width:99.999999993%;*width:99.9468085036383%}.row-fluid .span11{width:91.436464082%;*width:91.38327259263829%}.row-fluid .span10{width:82.87292817100001%;*width:82.8197366816383%}.row-fluid .span9{width:74.30939226%;*width:74.25620077063829%}.row-fluid .span8{width:65.74585634900001%;*width:65.6926648596383%}.row-fluid .span7{width:57.182320438000005%;*width:57.129128948638304%}.row-fluid .span6{width:48.618784527%;*width:48.5655930376383%}.row-fluid .span5{width:40.055248616%;*width:40.0020571266383%}.row-fluid .span4{width:31.491712705%;*width:31.4385212156383%}.row-fluid .span3{width:22.928176794%;*width:22.874985304638297%}.row-fluid .span2{width:14.364640883%;*width:14.311449393638298%}.row-fluid .span1{width:5.801104972%;*width:5.747913482638298%}input,textarea,.uneditable-input{margin-left:0}input.span12,textarea.span12,.uneditable-input.span12{width:714px}input.span11,textarea.span11,.uneditable-input.span11{width:652px}input.span10,textarea.span10,.uneditable-input.span10{width:590px}input.span9,textarea.span9,.uneditable-input.span9{width:528px}input.span8,textarea.span8,.uneditable-input.span8{width:466px}input.span7,textarea.span7,.uneditable-input.span7{width:404px}input.span6,textarea.span6,.uneditable-input.span6{width:342px}input.span5,textarea.span5,.uneditable-input.span5{width:280px}input.span4,textarea.span4,.uneditable-input.span4{width:218px}input.span3,textarea.span3,.uneditable-input.span3{width:156px}input.span2,textarea.span2,.uneditable-input.span2{width:94px}input.span1,textarea.span1,.uneditable-input.span1{width:32px}}@media(min-width:1200px){.row{margin-left:0px;*zoom:1}.row:before,.row:after{display:table;content:""}.row:after{clear:both}[class*="span"]{float:left;margin-left:30px}.container,.navbar-fixed-top .container,.navbar-fixed-bottom .container{width:1170px}.span12{width:1170px}.span11{width:1070px}.span10{width:970px}.span9{width:870px}.span8{width:770px}.span7{width:670px}.span6{width:570px}.span5{width:470px}.span4{width:370px}.span3{width:270px}.span2{width:170px}.span1{width:70px}.offset12{margin-left:1230px}.offset11{margin-left:1130px}.offset10{margin-left:1030px}.offset9{margin-left:930px}.offset8{margin-left:830px}.offset7{margin-left:730px}.offset6{margin-left:630px}.offset5{margin-left:530px}.offset4{margin-left:430px}.offset3{margin-left:330px}.offset2{margin-left:230px}.offset1{margin-left:130px}.row-fluid{width:100%;*zoom:1}.row-fluid:before,.row-fluid:after{display:table;content:""}.row-fluid:after{clear:both}.row-fluid [class*="span"]{display:block;float:left;width:100%;min-height:28px;margin-left:2.564102564%;*margin-left:2.510911074638298%;-webkit-box-sizing:border-box;-moz-box-sizing:border-box;-ms-box-sizing:border-box;box-sizing:border-box}.row-fluid [class*="span"]:first-child{margin-left:0}.row-fluid .span12{width:100%;*width:99.94680851063829%}.row-fluid .span11{width:91.45299145300001%;*width:91.3997999636383%}.row-fluid .span10{width:82.905982906%;*width:82.8527914166383%}.row-fluid .span9{width:74.358974359%;*width:74.30578286963829%}.row-fluid .span8{width:65.81196581200001%;*width:65.7587743226383%}.row-fluid .span7{width:57.264957265%;*width:57.2117657756383%}.row-fluid .span6{width:48.717948718%;*width:48.6647572286383%}.row-fluid .span5{width:40.170940171000005%;*width:40.117748681638304%}.row-fluid .span4{width:31.623931624%;*width:31.5707401346383%}.row-fluid .span3{width:23.076923077%;*width:23.0237315876383%}.row-fluid .span2{width:14.529914530000001%;*width:14.4767230406383%}.row-fluid .span1{width:5.982905983%;*width:5.929714493638298%}input,textarea,.uneditable-input{margin-left:0}input.span12,textarea.span12,.uneditable-input.span12{width:1160px}input.span11,textarea.span11,.uneditable-input.span11{width:1060px}input.span10,textarea.span10,.uneditable-input.span10{width:960px}input.span9,textarea.span9,.uneditable-input.span9{width:860px}input.span8,textarea.span8,.uneditable-input.span8{width:760px}input.span7,textarea.span7,.uneditable-input.span7{width:660px}input.span6,textarea.span6,.uneditable-input.span6{width:560px}input.span5,textarea.span5,.uneditable-input.span5{width:460px}input.span4,textarea.span4,.uneditable-input.span4{width:360px}input.span3,textarea.span3,.uneditable-input.span3{width:260px}input.span2,textarea.span2,.uneditable-input.span2{width:160px}input.span1,textarea.span1,.uneditable-input.span1{width:60px}.thumbnails{margin-left:-30px}.thumbnails>li{margin-left:30px}.row-fluid .thumbnails{margin-left:0}}@media(max-width:979px){body{padding-top:0}.navbar-fixed-top,.navbar-fixed-bottom{position:static}.navbar-fixed-top{margin-bottom:18px}.navbar-fixed-bottom{margin-top:18px}.navbar-fixed-top .navbar-inner,.navbar-fixed-bottom .navbar-inner{padding:5px}.navbar .container{width:auto;padding:0}.navbar .brand{padding-right:10px;padding-left:10px;margin:0 0 0 -5px}.nav-collapse{clear:both}.nav-collapse .nav{float:none;margin:0 0 9px}.nav-collapse .nav>li{float:none}.nav-collapse .nav>li>a{margin-bottom:2px}.nav-collapse .nav>.divider-vertical{display:none}.nav-collapse .nav .nav-header{color:#ddd;text-shadow:none}.nav-collapse .nav>li>a,.nav-collapse .dropdown-menu a{padding:6px 15px;font-weight:bold;color:#ddd;-webkit-border-radius:3px;-moz-border-radius:3px;border-radius:3px}.nav-collapse .btn{padding:4px 10px 4px;font-weight:normal;-webkit-border-radius:4px;-moz-border-radius:4px;border-radius:4px}.nav-collapse .dropdown-menu li+li a{margin-bottom:2px}.nav-collapse .nav>li>a:hover,.nav-collapse .dropdown-menu a:hover{background-color:#13459a}.nav-collapse.in .btn-group{padding:0;margin-top:5px}.nav-collapse .dropdown-menu{position:static;top:auto;left:auto;display:block;float:none;max-width:none;padding:0;margin:0 15px;background-color:transparent;border:0;-webkit-border-radius:0;-moz-border-radius:0;border-radius:0;-webkit-box-shadow:none;-moz-box-shadow:none;box-shadow:none}.nav-collapse .dropdown-menu:before,.nav-collapse .dropdown-menu:after{display:none}.nav-collapse .dropdown-menu .divider{display:none}.nav-collapse .navbar-form,.nav-collapse .navbar-search{float:none;padding:9px 15px;margin:9px 0;border-top:1px solid #13459a;border-bottom:1px solid #13459a;-webkit-box-shadow:inset 0 1px 0 rgba(255,255,255,0.1),0 1px 0 rgba(255,255,255,0.1);-moz-box-shadow:inset 0 1px 0 rgba(255,255,255,0.1),0 1px 0 rgba(255,255,255,0.1);box-shadow:inset 0 1px 0 rgba(255,255,255,0.1),0 1px 0 rgba(255,255,255,0.1)}.navbar .nav-collapse .nav.pull-right{float:none;margin-left:0}.nav-collapse,.nav-collapse.collapse{height:0;overflow:hidden}.navbar .btn-navbar{display:block}.navbar-static .navbar-inner{padding-right:10px;padding-left:10px}}@media(min-width:980px){.nav-collapse.collapse{height:auto!important;overflow:visible!important}}.clearfix{*zoom:1}.clearfix:before,.clearfix:after{display:table;content:""}.clearfix:after{clear:both}.hide-text{font:0/0 a;color:transparent;text-shadow:none;background-color:transparent;border:0}.input-block-level{display:block;width:100%;min-height:28px;-webkit-box-sizing:border-box;-moz-box-sizing:border-box;-ms-box-sizing:border-box;box-sizing:border-box}.hidden{display:none;visibility:hidden}.visible-phone{display:none!important}.visible-tablet{display:none!important}.hidden-desktop{display:none!important}@media(max-width:767px){.visible-phone{display:inherit!important}.hidden-phone{display:none!important}.hidden-desktop{display:inherit!important}.visible-desktop{display:none!important}}@media(min-width:768px) and (max-width:979px){.visible-tablet{display:inherit!important}.hidden-tablet{display:none!important}.hidden-desktop{display:inherit!important}.visible-desktop{display:none!important}}@media(max-width:480px){.nav-collapse{-webkit-transform:translate3d(0,0,0)}.page-header h1 small{display:block;line-height:18px}input[type="checkbox"],input[type="radio"]{border:1px solid #ccc}.form-horizontal .control-group>label{float:none;width:auto;padding-top:0;text-align:left}.form-horizontal .controls{margin-left:0}.form-horizontal .control-list{padding-top:0}.form-horizontal .form-actions{padding-right:10px;padding-left:10px}.modal{position:absolute;top:10px;right:10px;left:10px;width:auto;margin:0}.modal.fade.in{top:auto}.modal-header .close{padding:10px;margin:-10px}.carousel-caption{position:static}}@media(max-width:767px){body{padding-right:20px;padding-left:20px}.navbar-fixed-top,.navbar-fixed-bottom{margin-right:-20px;margin-left:-20px}.container-fluid{padding:0}.dl-horizontal dt{float:none;width:auto;clear:none;text-align:left}.dl-horizontal dd{margin-left:0}.container{width:auto}.row-fluid{width:100%}.row,.thumbnails{margin-left:0}[class*="span"],.row-fluid [class*="span"]{display:block;float:none;width:auto;margin-left:0}.input-large,.input-xlarge,.input-xxlarge,input[class*="span"],select[class*="span"],textarea[class*="span"],.uneditable-input{display:block;width:100%;min-height:28px;-webkit-box-sizing:border-box;-moz-box-sizing:border-box;-ms-box-sizing:border-box;box-sizing:border-box}.input-prepend input,.input-append input,.input-prepend input[class*="span"],.input-append input[class*="span"]{display:inline-block;width:auto}}@media(min-width:768px) and (max-width:979px){.row{margin-left:-20px;*zoom:1}.row:before,.row:after{display:table;content:""}.row:after{clear:both}[class*="span"]{float:left;margin-left:20px}.container,.navbar-fixed-top .container,.navbar-fixed-bottom .container{width:724px}.span12{width:724px}.span11{width:662px}.span10{width:600px}.span9{width:538px}.span8{width:476px}.span7{width:414px}.span6{width:352px}.span5{width:290px}.span4{width:228px}.span3{width:166px}.span2{width:104px}.span1{width:42px}.offset12{margin-left:764px}.offset11{margin-left:702px}.offset10{margin-left:640px}.offset9{margin-left:578px}.offset8{margin-left:516px}.offset7{margin-left:454px}.offset6{margin-left:392px}.offset5{margin-left:330px}.offset4{margin-left:268px}.offset3{margin-left:206px}.offset2{margin-left:144px}.offset1{margin-left:82px}.row-fluid{width:100%;*zoom:1}.row-fluid:before,.row-fluid:after{display:table;content:""}.row-fluid:after{clear:both}.row-fluid [class*="span"]{display:block;float:left;width:100%;min-height:28px;margin-left:2.762430939%;*margin-left:2.709239449638298%;-webkit-box-sizing:border-box;-moz-box-sizing:border-box;-ms-box-sizing:border-box;box-sizing:border-box}.row-fluid [class*="span"]:first-child{margin-left:0}.row-fluid .span12{width:99.999999993%;*width:99.9468085036383%}.row-fluid .span11{width:91.436464082%;*width:91.38327259263829%}.row-fluid .span10{width:82.87292817100001%;*width:82.8197366816383%}.row-fluid .span9{width:74.30939226%;*width:74.25620077063829%}.row-fluid .span8{width:65.74585634900001%;*width:65.6926648596383%}.row-fluid .span7{width:57.182320438000005%;*width:57.129128948638304%}.row-fluid .span6{width:48.618784527%;*width:48.5655930376383%}.row-fluid .span5{width:40.055248616%;*width:40.0020571266383%}.row-fluid .span4{width:31.491712705%;*width:31.4385212156383%}.row-fluid .span3{width:22.928176794%;*width:22.874985304638297%}.row-fluid .span2{width:14.364640883%;*width:14.311449393638298%}.row-fluid .span1{width:5.801104972%;*width:5.747913482638298%}input,textarea,.uneditable-input{margin-left:0}input.span12,textarea.span12,.uneditable-input.span12{width:714px}input.span11,textarea.span11,.uneditable-input.span11{width:652px}input.span10,textarea.span10,.uneditable-input.span10{width:590px}input.span9,textarea.span9,.uneditable-input.span9{width:528px}input.span8,textarea.span8,.uneditable-input.span8{width:466px}input.span7,textarea.span7,.uneditable-input.span7{width:404px}input.span6,textarea.span6,.uneditable-input.span6{width:342px}input.span5,textarea.span5,.uneditable-input.span5{width:280px}input.span4,textarea.span4,.uneditable-input.span4{width:218px}input.span3,textarea.span3,.uneditable-input.span3{width:156px}input.span2,textarea.span2,.uneditable-input.span2{width:94px}input.span1,textarea.span1,.uneditable-input.span1{width:32px}}@media(min-width:1200px){.row{margin-left:0px;*zoom:1}.row:before,.row:after{display:table;content:""}.row:after{clear:both}[class*="span"]{float:left;margin-left:30px}.container,.navbar-fixed-top .container,.navbar-fixed-bottom .container{width:1170px}.span12{width:1170px}.span11{width:1070px}.span10{width:970px}.span9{width:870px}.span8{width:770px}.span7{width:670px}.span6{width:570px}.span5{width:470px}.span4{width:370px}.span3{width:270px}.span2{width:170px}.span1{width:70px}.offset12{margin-left:1230px}.offset11{margin-left:1130px}.offset10{margin-left:1030px}.offset9{margin-left:930px}.offset8{margin-left:830px}.offset7{margin-left:730px}.offset6{margin-left:630px}.offset5{margin-left:530px}.offset4{margin-left:430px}.offset3{margin-left:330px}.offset2{margin-left:230px}.offset1{margin-left:130px}.row-fluid{width:100%;*zoom:1}.row-fluid:before,.row-fluid:after{display:table;content:""}.row-fluid:after{clear:both}.row-fluid [class*="span"]{display:block;float:left;width:100%;min-height:28px;margin-left:2.564102564%;*margin-left:2.510911074638298%;-webkit-box-sizing:border-box;-moz-box-sizing:border-box;-ms-box-sizing:border-box;box-sizing:border-box}.row-fluid [class*="span"]:first-child{margin-left:0}.row-fluid .span12{width:100%;*width:99.94680851063829%}.row-fluid .span11{width:91.45299145300001%;*width:91.3997999636383%}.row-fluid .span10{width:82.905982906%;*width:82.8527914166383%}.row-fluid .span9{width:74.358974359%;*width:74.30578286963829%}.row-fluid .span8{width:65.81196581200001%;*width:65.7587743226383%}.row-fluid .span7{width:57.264957265%;*width:57.2117657756383%}.row-fluid .span6{width:48.717948718%;*width:48.6647572286383%}.row-fluid .span5{width:40.170940171000005%;*width:40.117748681638304%}.row-fluid .span4{width:31.623931624%;*width:31.5707401346383%}.row-fluid .span3{width:23.076923077%;*width:23.0237315876383%}.row-fluid .span2{width:14.529914530000001%;*width:14.4767230406383%}.row-fluid .span1{width:5.982905983%;*width:5.929714493638298%}input,textarea,.uneditable-input{margin-left:0}input.span12,textarea.span12,.uneditable-input.span12{width:1160px}input.span11,textarea.span11,.uneditable-input.span11{width:1060px}input.span10,textarea.span10,.uneditable-input.span10{width:960px}input.span9,textarea.span9,.uneditable-input.span9{width:860px}input.span8,textarea.span8,.uneditable-input.span8{width:760px}input.span7,textarea.span7,.uneditable-input.span7{width:660px}input.span6,textarea.span6,.uneditable-input.span6{width:560px}input.span5,textarea.span5,.uneditable-input.span5{width:460px}input.span4,textarea.span4,.uneditable-input.span4{width:360px}input.span3,textarea.span3,.uneditable-input.span3{width:260px}input.span2,textarea.span2,.uneditable-input.span2{width:160px}input.span1,textarea.span1,.uneditable-input.span1{width:60px}.thumbnails{margin-left:-30px}.thumbnails>li{margin-left:30px}.row-fluid .thumbnails{margin-left:0}}@media(max-width:979px){body{padding-top:0}.navbar-fixed-top,.navbar-fixed-bottom{position:static}.navbar-fixed-top{margin-bottom:18px}.navbar-fixed-bottom{margin-top:18px}.navbar-fixed-top .navbar-inner,.navbar-fixed-bottom .navbar-inner{padding:5px}.navbar .container{width:auto;padding:0}.navbar .brand{padding-right:10px;padding-left:10px;margin:0 0 0 -5px}.nav-collapse{clear:both}.nav-collapse .nav{float:none;margin:0 0 9px}.nav-collapse .nav>li{float:none}.nav-collapse .nav>li>a{margin-bottom:2px}.nav-collapse .nav>.divider-vertical{display:none}.nav-collapse .nav .nav-header{color:#ddd;text-shadow:none}.nav-collapse .nav>li>a,.nav-collapse .dropdown-menu a{padding:6px 15px;font-weight:bold;color:#ddd;-webkit-border-radius:3px;-moz-border-radius:3px;border-radius:3px}.nav-collapse .btn{padding:4px 10px 4px;font-weight:normal;-webkit-border-radius:4px;-moz-border-radius:4px;border-radius:4px}.nav-collapse .dropdown-menu li+li a{margin-bottom:2px}.nav-collapse .nav>li>a:hover,.nav-collapse .dropdown-menu a:hover{background-color:#13459a}.nav-collapse.in .btn-group{padding:0;margin-top:5px}.nav-collapse .dropdown-menu{position:static;top:auto;left:auto;display:block;float:none;max-width:none;padding:0;margin:0 15px;background-color:transparent;border:0;-webkit-border-radius:0;-moz-border-radius:0;border-radius:0;-webkit-box-shadow:none;-moz-box-shadow:none;box-shadow:none}.nav-collapse .dropdown-menu:before,.nav-collapse .dropdown-menu:after{display:none}.nav-collapse .dropdown-menu .divider{display:none}.nav-collapse .navbar-form,.nav-collapse .navbar-search{float:none;padding:9px 15px;margin:9px 0;border-top:1px solid #13459a;border-bottom:1px solid #13459a;-webkit-box-shadow:inset 0 1px 0 rgba(255,255,255,0.1),0 1px 0 rgba(255,255,255,0.1);-moz-box-shadow:inset 0 1px 0 rgba(255,255,255,0.1),0 1px 0 rgba(255,255,255,0.1);box-shadow:inset 0 1px 0 rgba(255,255,255,0.1),0 1px 0 rgba(255,255,255,0.1)}.navbar .nav-collapse .nav.pull-right{float:none;margin-left:0}.nav-collapse,.nav-collapse.collapse{height:0;overflow:hidden}.navbar .btn-navbar{display:block}.navbar-static .navbar-inner{padding-right:10px;padding-left:10px}}@media(min-width:980px){.nav-collapse.collapse{height:auto!important;overflow:visible!important}}
	</style>
    <style>
        .table-hover tbody tr:hover td
        {
            background-color: #C7E4D3;
        }
        
        .directoryTab .text-center
        {
            text-align: center;
        }
        .directoryTab .directoryTable
        {
            background-color: #C9F1FD;
        }
        .directoryTab .main
        {
            background-color: #FFFFFF;
        }
        .directoryTab .pad
        {
            padding-top: 15px;
            padding-left: 15px;
            padding-bottom: 15px;
        }
        .directoryTab .leftpanel
        {
            height: 500px;
            overflow-y: scroll;
            background-color: #c9f1fd;
        }
        .directoryTab .rightpanel
        {
            background-color: #C7E4D3;
            margin-left: 15px !important;
            border-radius: 12px;
            min-height: 500px;
        }
        
        .directoryTab .infinitescroll
        {
            width: 100%;
            height: 200px;
            overflow: auto;
        }
        .directoryTab .head
        {
            background-color: #C9F1FD;
            padding: 12px 12px 0;
            border-bottom: 8px solid #c9f1fd;
        }
        
        .directoryTab .email-padding
        {
            padding-right: 6px;
        }
        .directoryTab .img-small
        {
            padding-left: 6px;
        }
        .directoryTab .row-style
        {
            background-color: #ffffff;
            border-left: 12px solid #c9f1fd;
            border-right: 12px solid #c9f1fd;
            border-top: 4px solid #c9f1fd;
            height: 60px;
        }
        .directoryTab .underline
        {
            text-decoration: underline;
        }
        
        .directoryTab .padding-top
        {
            padding-top: 5%;
        }
        .directoryTab .small
        {
            font-size: 0.9em;
        }
        .directoryTab .stl
        {
            text-align: center;
            color: #5f5f5f;
            min-width: 50%;
            padding: 4px 0;
        }
        
        .directoryTab .stl2
        {
            text-align: left;
            color: #5f5f5f;
            min-width: 50%;
            padding: 4px 0;
        }
        
        .directoryTab .destd
        {
            color: #5F5F5F;
        }
        .directoryTab .empno
        {
            color: #5F5F5F;
        }
        .directoryTab .img-circle
        {
            width: 130px;
            height: 130px;
            border-radius: 100px;
            border: 2px solid #8AB872;
        }
        
        .directoryTab .right-inner-addon
        {
            position: relative;
            height: 60px;
            width: 498px;
            background-color: #E8F6FA;
        }
        
        .directoryTab .right-inner-addon i
        {
            position: absolute;
            padding: 24px 35px;
        }
        
        .directoryTab .search
        {
            border: medium none;
            border-radius: 25px;
            height: 28px;
            margin: 13px 0 0 13px;
            padding: 5px 37px 2px 38px;
            width: 400px;
        }
        
        .directoryTab .search:hover
        {
            border: 1px solid #CFD8E1;
        }
        
        .directoryTab .dir
        {
            /*--background-color: #fff;--*/
            border-radius: 4px;
            padding: 12px;
            width: 1080px;
            margin-left: 20px;
        }
        
        .directoryTab .nav-tabs
        {
            border-bottom: none;
            margin: 0 0 1px;
        }
        
        .directoryTab .nav-tabs > .active > a, .directoryTab .nav-tabs > .active > a:hover
        {
            -moz-border-bottom-colors: none;
            -moz-border-left-colors: none;
            -moz-border-right-colors: none;
            -moz-border-top-colors: none;
            background-color: #c9f1fd;
            border-color: none;
            border-image: none;
            border-style: none;
            border-width: 1px;
            color: #2534AB;
            cursor: default;
        }
        
        .directoryTab .nav-tabs > a
        {
            -moz-border-bottom-colors: none;
            -moz-border-left-colors: none;
            -moz-border-right-colors: none;
            -moz-border-top-colors: none;
            background-color: #ffffff;
            border-color: #555555;
            border-image: none;
            border-style: 1px solid #745592;
            border-width: 1px;
            color: #745592;
            cursor: default;
        }
    </style>
    <script type="text/javascript">
        $(function () {
            GetEmployeeDeatails();
            getpayslipdetails();
            getanualdetails();
            get_Employeedetails();
            get_salaryytd_Details();
            get_pf_Details();
            get_anualit_Details();
            get_incmtax_Details();
            var usrphoto = '<%=Session["photo"] %>';
            var rndmnum = Math.floor((Math.random() * 10) + 1);
            var ftplocation = "http://182.18.138.228:81/";
            img = ftplocation + usrphoto + '?v=' + rndmnum;
            document.getElementById("imguser").src = img;
        });
        function callHandler(d, s, e) {
            $.ajax({
                url: 'EmployeeManagementHandler.axd',
                data: d,
                type: 'GET',
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                async: true,
                cache: true,
                success: s,
                error: e
            });
        }
        function CallHandlerUsingJson(d, s, e) {
            d = JSON.stringify(d);
            d = d.replace(/&/g, '\uFF06');
            d = d.replace(/#/g, '\uFF03');
            d = d.replace(/\+/g, '\uFF0B');
            d = d.replace(/\=/g, '\uFF1D');
            $.ajax({
                type: "GET",
                url: "EmployeeManagementHandler.axd?json=",
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                data: d,
                async: true,
                cache: true,
                success: s,
                error: e
            });
        }
        function GettotalclsCal() {
            var totamount = 0;
            $('.tammountcls').each(function (i, obj) {
                var qtyclass = $(this).text();
                if (qtyclass == "" || qtyclass == "0") {
                }
                else {
                    totamount += parseFloat(qtyclass);
                }
            });
            document.getElementById('totalcls').innerHTML = parseFloat(totamount).toFixed(2);
        }
        function Gettotal_itclsCal() {
            var totamount = 0;
            $('.it_total').each(function (i, obj) {
                var qtyclass = $(this).text();
                if (qtyclass == "" || qtyclass == "0") {
                }
                else {
                    totamount += parseFloat(qtyclass);
                }
            });
            document.getElementById('it_totalcls').innerHTML = parseFloat(totamount).toFixed(2);
        }
        var employeedetails = [];
        function get_Employeedetails() {
            var data = { 'op': 'get_all_dash_employeedetails' };
            var s = function (msg) {
                if (msg) {
                    filltable(msg);
                    employeedetails = msg;
                    var empnameList = [];
                    for (var i = 0; i < msg.length; i++) {
                        var empname = msg[i].empname;
                        empnameList.push(empname);
                    }
                    $('#selct_employe').autocomplete({
                        source: empnameList,
                        change: employeenamechange,
                        autoFocus: true
                    });
                }
            }
            var e = function (x, h, e) {
                alert(e.toString());
            };
            callHandler(data, s, e);
        }
        function filltable(msg) {
            var results = '<div style="overflow:auto;"><table id="tbl_employe" style="width:100%;" class="director yTable everyOneTable table-hover">';
            results += '<thead><tr></th><th scope="col" ></th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                var img_url = "";
                var ftplocation = "http://182.18.138.228:81/";
                var rndmnum = Math.floor((Math.random() * 10) + 1);
                img_url = ftplocation + msg[i].photo + '?v=' + rndmnum;
                if (msg[i].photo != "") {
                    img_url = ftplocation + msg[i].photo + '?v=' + rndmnum;
                }
                else {
                    img_url = "Images/Employeeimg.jpg";
                }
                results += '<tr class="row-style highlight">';
                results += '<td class="1"><span id="spn1" onclick="getme(this)"> <img src=' + img_url + '  style="cursor:pointer;height:50px;width:50px;border-radius:50%;"/>' + msg[i].empnamecode + '</span></td>';
                results += '<td style="display:none;" class="2">' + msg[i].empname + '</td>';
                results += '<td style="display:none;" class="3">' + img_url + '</td>';
                results += '<td style="display:none;" class="4">' + msg[i].email + '</td>';
                results += '<td style="display:none;" class="5">' + msg[i].cellphone + '</td>';
                results += '<td style="display:none;" class="6">' + msg[i].branchname + '</td>';
                results += '<td style="display:none;" class="7">' + msg[i].empnum + '</td>';
                results += '<td style="display:none;" class="8">' + msg[i].designation + '</td>';
                results += '<td style="display:none;" class="9">' + msg[i].joindate + '</td>';
                results += '<td style="display:none;" class="12">' + msg[i].empsno + '</td></tr>';
            }
            results += '</table></div>';
            $("#div_Employeedata").html(results);
        }
        function employeenamechange(msg) {
            var empname = document.getElementById('selct_employe').value;
            if (empname != "") {
                for (var i = 0; i < employeedetails.length; i++) {
                    if (empname == employeedetails[i].empname) {
                        document.getElementById('txtsupid').value = employeedetails[i].empsno;
                        var results = '<div style="overflow:auto;"><table style="width:100%;" class="director yTable everyOneTable table-hover">';
                        results += '<thead><tr></th><th scope="col" ></th></tr></thead></tbody>';
                        var img_url = "";
                        var ftplocation = "http://182.18.138.228:81/";
                        var rndmnum = Math.floor((Math.random() * 10) + 1);
                        img_url = ftplocation + employeedetails[i].photo + '?v=' + rndmnum;
                        if (employeedetails[i].photo != "") {
                            img_url = ftplocation + employeedetails[i].photo + '?v=' + rndmnum;
                        }
                        else {
                            img_url = "Images/Employeeimg.jpg";
                        }
                        results += '<tr class="row-style highlight">';
                        results += '<td><span onclick="getme(this)" class="spnemp" ><img src=' + img_url + '  style="cursor:pointer;height:50px;width:50px;border-radius:50%;padding-right:5px;"/>' + employeedetails[i].empnamecode + '</span></td>';
                        results += '<td style="display:none;" class="2">' + employeedetails[i].empname + '</td>';
                        results += '<td style="display:none;" class="3">' + img_url + '</td>';
                        results += '<td style="display:none;" class="4">' + employeedetails[i].email + '</td>';
                        results += '<td style="display:none;" class="5">' + employeedetails[i].cellphone + '</td>';
                        results += '<td style="display:none;" class="6">' + employeedetails[i].branchname + '</td>';
                        results += '<td style="display:none;" class="7">' + employeedetails[i].empnum + '</td>';
                        results += '<td style="display:none;" class="8">' + employeedetails[i].designation + '</td>';
                        results += '<td style="display:none;" class="9">' + employeedetails[i].joindate + '</td>';
                        results += '<td style="display:none;" class="12">' + employeedetails[i].empsno + '</td></tr>';
                    }
                }
                results += '</table></div>';
                $("#div_Employeedata").html(results);
            }
            else {
                get_Employeedetails();
            }
        }
        function getme(thisid) {
            var sno = $(thisid).parent().parent().children('.12').html();
            var empname = $(thisid).parent().parent().children('.2').html();
            var imgurl = $(thisid).parent().parent().children('.3').html();
            var email = $(thisid).parent().parent().children('.4').html();
            var branchname = $(thisid).parent().parent().children('.6').html();
            var mobileno = $(thisid).parent().parent().children('.5').html();
            var empnum = $(thisid).parent().parent().children('.7').html();
            var role = $(thisid).parent().parent().children('.8').html();
            var joindate = $(thisid).parent().parent().children('.9').html();
            document.getElementById("lblname").innerHTML = empname;
            document.getElementById("lbllocation").innerHTML = branchname;
            document.getElementById("lblcode").innerHTML = empnum;
            document.getElementById("img1").src = imgurl;
            document.getElementById("lblrole").innerHTML = role;
            document.getElementById("lbljoindate").innerHTML = joindate;
            document.getElementById("lblcontact").innerHTML = mobileno;
            document.getElementById("lblemail").innerHTML = email;
            // 
        }
        //        function getpayslipdetails() {
        //            var empid = '<%=Session["empid"] %>';
        //            var noofmonths = 1;
        //            var data = { 'op': 'get_paysalary_Details', 'empid': empid, 'noofmonths': noofmonths };
        //            var s = function (msg) {
        //                if (msg) {
        //                    for (var i = 0; i < msg.length; i++) {
        //                        document.getElementById("lblgrosspay").innerHTML = msg[i].monthsal;
        //                        document.getElementById("lbldeduction").innerHTML = msg[i].totaldeduction;
        //                        document.getElementById("lblnetpay").innerHTML = msg[i].netamount;

        //                        document.getElementById("lblagrosspay").innerHTML = msg[i].monthsal;
        //                        document.getElementById("lbladeduction").innerHTML = msg[i].totaldeduction;
        //                        document.getElementById("lblanetpay").innerHTML = msg[i].netamount;
        //                    }
        //                }
        //            }
        //            var e = function (x, h, e) {
        //                alert(e.toString());
        //            };
        //            callHandler(data, s, e);
        //        }





        function GetEmployeeDeatails() {

            var data = { 'op': 'get_all_dash_employeedetails' };
            var s = function (msg) {
                if (msg) {
                    if (msg) {
                        fillnew_employee_list(msg);
                        fillnew_employee = msg;
                    }
                    else {
                    }
                }
            };
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        function fillnew_employee_list(msg) {
            document.getElementById("lbluname").innerHTML = '<%=Session["fullname"] %>';
            for (var i = 0; i < msg.length; i++) {
                var tablerowcnt = document.getElementById("tbl_new_employee_list").rows.length;
                var empname = msg[i].empname + " - " + msg[i].empnum;
                var email = msg[i].email;
                var cellphone = msg[i].cellphone;
                var jdays = msg[i].joingdays;
                var joingdays = parseInt(jdays);
                var img_url = "";
                var placeholder = "";

                var jBirthDays = msg[i].BirthDays;
                var BirthDays = parseInt(jBirthDays);
                if (BirthDays < 10) {
                    if (joingyears == 2) {
                        img_url = "http://182.18.162.51/HRMS/Wishes/birthday2.png";
                    }
                    if (joingyears == 3) {
                        img_url = "http://182.18.162.51/HRMS/Wishes/birthday3.png";
                    }
                    else {
                        img_url = "http://182.18.162.51/HRMS/Wishes/birthday.png";
                    }
                    placeholder = "Happy Birthday " + msg[i].empname + " Have a great year ahead!";
                }

                if (joingdays > 60) {
                }
                else {
                    if (joingyears > 0 && joingyears < 20) {
                        img_url = "http://182.18.162.51/HRMS/Wishes/Welcome.png";
                    }
                    if (joingyears > 10 && joingyears < 40) {
                        img_url = "http://182.18.162.51/HRMS/Wishes/Welcome2.png";
                    }
                    if (joingyears > 40 && joingyears < 60) {
                        img_url = "http://182.18.162.51/HRMS/Wishes/Welcome3.png";
                    }
                    placeholder = msg[i].empname + " has joined us in the company on " + msg[i].birthdate;
                }
                var jyears = msg[i].joingyears;
                var joingyears = parseInt(jyears);
                if (joingyears >= 1) {
                    if (joingyears == 2) {
                        img_url = "http://182.18.162.51/HRMS/Wishes/anniversary1.png";
                    }
                    else {
                        img_url = "http://182.18.162.51/HRMS/Wishes/anniversary.png";
                    }
                    placeholder = "Our congratulations to " + msg[i].empname + " on completing " + joingyears + " successful year. ";
                }

                var jyears = msg[i].joingyears;
                var joingyears = parseInt(jyears);
                if (joingyears >= 1) {
                }
                //                if (joingyears == 2) {
                //                    img_url = "Wishes/anniversary.png";
                //                }
                else {
                    if (img_url == "") {
                        img_url = "http://182.18.162.51/HRMS/Wishes/anniversary1.png";
                        //img_url = "Wishes/anniversary.png";
                        //                        }
                        //                        if(joingyears == 2) {
                        //                        img_url = "Wishes/anniversary.png";
                        //                    }
                        //placeholder = "Our congratulations to " + msg[i].empname + " on completing " + joingyears + " successful year. ";
                    }
                    else {
                    }
                    if (joingyears == 2) {
                        img_url = "http://182.18.162.51/HRMS/Wishes/anniversary.png";
                    }
                    else {
                        if (img_url == "") {
                            //img_url = "Wishes/anniversary1.png";
                            img_url = "http://182.18.162.51/HRMS/Wishes/anniversary.png";
                            //                        }
                            //                        if(joingyears == 2) {
                            //                        img_url = "Wishes/anniversary.png";
                            //                    }

                        }
                    }
                    placeholder = "Our congratulations to " + msg[i].empname + " on completing " + joingyears + " successful year. ";
                }
                var email;
                var img_url;
                var cellphone;
                $('#tbl_new_employee_list').append('<tr><th scope="Category Name" style="color: #3c8dbc;"><br/></th></tr>');
                $('#tbl_new_employee_list').append('<tr><th scope="Category Name" style="color: #999;padding-left: 10%;" >' + placeholder + '</th></tr>');
                $('#tbl_new_employee_list').append('<tr><th scope="Category Name" style="color: #3c8dbc;"><br/></th></tr>');
                $('#tbl_new_employee_list').append('<tr><th scope="Category Name" style="color: #3c8dbc;"><img src=' + img_url + '  style="cursor:pointer;border-radius: 5px;"/></th></tr>');
                $('#tbl_new_employee_list').append('<tr><th scope="Category Name" style="color: #3c8dbc;"><br/></th></tr>');
                $('#tbl_new_employee_list').append('<tr><th scope="Category Name" style="color: #3c8dbc; padding-left:10px;"><textarea id="txtremarks" placeholder="Enter Wishes" class="form-control" rows="1" cols="2" style="width:500px;"></textarea><span style="padding-left:465px;"   onclick="sendmailclick(\'' + email + '\',\'' + img_url + '\');"><i class="fa fa-arrow-circle-right"  aria-hidden="true"></i>Send</span></th></tr>');
                $('#tbl_new_employee_list').append('<tr><th scope="Category Name" style="color: #3c8dbc; padding-left:10px;"><textarea id="txtremarks" placeholder="Enter Wishes" class="form-control" rows="1" cols="2" style="width:500px;"></textarea><span style="padding-left:465px;"  onclick="sendmobileclick(\'' + img_url + '\',\'' + cellphone + '\');"><i class="fa fa-arrow-circle-right"  aria-hidden="true"></i>Send</span></th></tr>');
                $('#tbl_new_employee_list').append('<tr><th scope="Category Name" style="color: #3c8dbc;"><br/></th></tr>');
            }
        }
        function sendmailclick(email, img_url) {
            var email;
            var img_url;
            //var cellphone;
            //var mailid = "email";
            //var mailid = ID.value;
            //var mailid = document.getElementById("ak").innerHTML;
            var data = { 'op': 'send_employee_wishes_mail', 'img_url': img_url, 'email': email };
            var s = function (msg) {
                if (msg) {
                    if (msg) {
                        alert(msg);
                    }
                    else {
                    }
                }
            };
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }

        function sendmobileclick(img_url, cellphone) {
            //var email;
            var img_url;
            var cellphone;
            //var mailid = "email";
            //var mailid = ID.value;
            //var mailid = document.getElementById("ak").innerHTML;
            var data = { 'op': 'send_employee_wishes_moblie', 'img_url': img_url, 'cellphone': cellphone };
            var s = function (msg) {
                if (msg) {
                    if (msg) {
                        alert(msg);
                    }
                    else {
                    }
                }
            };
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        function spnevents() {
            document.getElementById("lbluname").innerHTML = '<%=Session["fullname"] %>';
            $('#tbl_new_employee_list').empty();
            var data = { 'op': 'get_all_dash_employeedetails' };
            var s = function (msg) {
                if (msg) {
                    if (msg) {
                        for (var i = 0; i < msg.length; i++) {
                            var tablerowcnt = document.getElementById("tbl_new_employee_list").rows.length;
                            var empname = msg[i].empname + " - " + msg[i].empnum;
                            var email = msg[i].email;
                            var cellphone = msg[i].cellphone;
                            var jdays = msg[i].joingdays;
                            var joingdays = parseInt(jdays);
                            var img_url = "";
                            var placeholder = "";
                            var bdays = msg[i].Birth_Days;
                            var currentdate = msg[i].currentdate
                            if (bdays < 10) {

                                img_url = "http://182.18.162.51/HRMS/Wishes/Welcome.png";

                                placeholder = "Happy Birthday " + msg[i].empname + " Have a great year ahead!";
                                var email;
                                var img_url;
                                var cellphone;
                                $('#tbl_new_employee_list').append('<tr><th scope="Category Name" style="color: #3c8dbc;"><br/></th></tr>');
                                $('#tbl_new_employee_list').append('<tr><th scope="Category Name" style="color: #999;padding-left: 10%;" >' + placeholder + '</th></tr>');
                                $('#tbl_new_employee_list').append('<tr><th scope="Category Name" style="color: #3c8dbc;"><br/></th></tr>');
                                $('#tbl_new_employee_list').append('<tr><th scope="Category Name" style="color: #3c8dbc;"><img src=' + img_url + '  style="cursor:pointer;border-radius: 5px;"/></th></tr>');
                                $('#tbl_new_employee_list').append('<tr><th scope="Category Name" style="color: #3c8dbc;"><br/></th></tr>');
                                $('#tbl_new_employee_list').append('<tr><th scope="Category Name" style="color: #3c8dbc; padding-left:10px;"><textarea id="txtremarks" placeholder="Enter Wishes" class="form-control" rows="1" cols="2" style="width:500px;"></textarea><span  onclick="sendmailclick(\'' + email + '\',\'' + img_url + '\');"><i class="fa fa-arrow-circle-right"  aria-hidden="true"></i>Send</span></th></tr>');
                                $('#tbl_new_employee_list').append('<tr><th scope="Category Name" style="color: #3c8dbc; padding-left:10px;"><textarea id="txtremarks" placeholder="Enter Wishes" class="form-control" rows="1" cols="2" style="width:428px;"></textarea><span style="padding-left:465px;"  onclick="sendmobileclick(\'' + img_url + '\',\'' + cellphone + '\');"><i class="fa fa-arrow-circle-right"  aria-hidden="true"></i>Send</span></th></tr>');
                                $('#tbl_new_employee_list').append('<tr><th scope="Category Name" style="color: #3c8dbc;"><br/></th></tr>');
                            }
                        }
                        var img_url = "http://182.18.162.51/HRMS/Wishes/Welcome.png";
                        $('#tbl_new_employee_list').append('<tr><th scope="Category Name" style="color: #3c8dbc;"><img src=' + img_url + '  style="cursor:pointer;border-radius: 5px;"/></th></tr>');
                    }
                    else {
                    }
                }
            };
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        function getpayslipdetails() {
            $('#divpayslips').css('display', 'block');
            var empid = '<%=Session["empid"] %>';
            var noofmonths = 1;
            var data = { 'op': 'get_paysalary_Details', 'empid': empid, 'noofmonths': noofmonths };
            var s = function (msg) {
                if (msg) {
                    for (var i = 0; i < msg.length; i++) {
                        document.getElementById("lblname").innerHTML = msg[i].empname;
                        document.getElementById("lblcode").innerHTML = msg[i].employeid;

                        document.getElementById("lblemail").innerHTML = msg[i].emailid;
                        document.getElementById("lblcontact").innerHTML = msg[i].contactno;
                        document.getElementById("lbljoindate").innerHTML = msg[i].joindate;
                        document.getElementById("lbllocation").innerHTML = msg[i].branchname;
                        document.getElementById("lblrole").innerHTML = msg[i].designation;                        

                        document.getElementById("lblgrosspay").innerHTML = msg[i].monthsal;
                        document.getElementById("lbldeduction").innerHTML = msg[i].totaldeduction;
                        document.getElementById("lblnetpay").innerHTML = msg[i].netamount;
                        document.getElementById("lblpgrosspay").innerHTML = msg[i].monthsal;
                        document.getElementById("lblpbasic").innerHTML = msg[i].erbasic;
                        document.getElementById("lblphra").innerHTML = msg[i].hre;
                        document.getElementById("lblpconve").innerHTML = msg[i].conveyance;
                        document.getElementById("lblpmedical").innerHTML = msg[i].medical;
                        document.getElementById("lblpwashing").innerHTML = msg[i].washingallowance;
                        document.getElementById("lblppt").innerHTML = msg[i].professionaltax;
                        document.getElementById("lblppf").innerHTML = msg[i].providentfound;
                        document.getElementById("lblesi").innerHTML = msg[i].esi;
                        document.getElementById("lblSalryadvance").innerHTML = msg[i].salaryadvance;
                        document.getElementById("lblLoan").innerHTML = msg[i].loanamount;
                        document.getElementById("lblcanteen").innerHTML = msg[i].canteendeduction;
                        document.getElementById("lblmbl").innerHTML = msg[i].mobilededuction;
                        document.getElementById("lblmedicliam").innerHTML = msg[i].mediclaimdeduction;
                        document.getElementById("lbltds").innerHTML = msg[i].tdsdeduction;
                        document.getElementById("lblotherdedu").innerHTML = msg[i].otherdeduction;
                        document.getElementById("lblpdeduction").innerHTML = msg[i].totaldeduction;
                        document.getElementById("lblpnetpay").innerHTML = msg[i].netamount;

                    }
                }
            }
            var e = function (x, h, e) {
                alert(e.toString());
            };
            callHandler(data, s, e);
        }
        function viewanualpf() {
            $('#divempdata').css('display', 'none');
            $('#divMainAddNewRow1').css('display', 'none');
            $('#divpfmainadnewrow').css('display', 'block');
            $('#divMainAddNewRow').css('display', 'none');
            $('#divincmtaxmainrow').css('display', 'none');
        }
        function viewanualerning() {
            $('#divempdata').css('display', 'none');
            $('#divMainAddNewRow1').css('display', 'block');
            $('#divpfmainadnewrow').css('display', 'none');
            $('#divMainAddNewRow').css('display', 'none');
            $('#divincmtaxmainrow').css('display', 'none');
        }
        function viewpayslipclick() {
            $('#divempdata').css('display', 'none');
            $('#divMainAddNewRow').css('display', 'block');
            $('#divpfmainadnewrow').css('display', 'none');
            $('#divMainAddNewRow1').css('display', 'none');
            $('#divincmtaxmainrow').css('display', 'none');
        }
        function viewanualinmtax() {
            $('#divincmtaxmainrow').css('display', 'block');
            $('#divempdata').css('display', 'none');
            $('#divMainAddNewRow').css('display', 'none');
            $('#divMainAddNewRow1').css('display', 'none');
            $('#divpfmainadnewrow').css('display', 'none');
        }
        function getanualdetails() {
            var empid = '<%=Session["empid"] %>';
            var data = { 'op': 'get_anualsalary_Details', 'empid': empid};
            var s = function (msg) {
                if (msg) {
                    for (var i = 0; i < msg.length; i++) {
                        document.getElementById("lblagrosspay").innerHTML = msg[i].gross;
                        document.getElementById("lblanetpay").innerHTML = msg[i].netamount;
                        document.getElementById("lbladeduction").innerHTML = msg[i].totaldeduction;
                        document.getElementById("lbl_pf").innerHTML = msg[i].Pf;
                    }
                }
            }
            var e = function (x, h, e) {
                alert(e.toString());
            };
            callHandler(data, s, e);
        }
        function get_anualit_Details() {
            var empid = '<%=Session["empid"] %>';
            var data = { 'op': 'get_anualit_Details', 'empid': empid };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        for (var i = 0; i < msg.length; i++) {
                            var tdsamnt = parseFloat(msg[i].TdsAmnt);
                            totamnt = parseFloat(tdsamnt * 12).toFixed(2);
                            document.getElementById("lblitpay").innerHTML = parseFloat(msg[i].txpaid);
                            document.getElementById("lbl_itax").innerHTML = parseFloat(msg[i].TdsAmnt);
                            document.getElementById("lbl_txpaid").innerHTML = totamnt; parseFloat(msg[i].txpaid);
                            totamnt_topay = parseFloat(msg[i].txpaid) - parseFloat(totamnt);
                            document.getElementById("lbl_totpay").innerHTML = parseFloat(totamnt_topay).toFixed(2);
                        }
                    }
                    else {
                        document.getElementById("lblitpay").innerHTML = "0.00";
                        document.getElementById("lbl_itax").innerHTML = "0.00";
                        document.getElementById("lbl_txpaid").innerHTML = "0.00";
                        document.getElementById("lbl_totpay").innerHTML = "0.00";
                    }
                }
            }
            var e = function (x, h, e) {
                alert(e.toString());
            };
            callHandler(data, s, e);
        }

        function get_salaryytd_Details() {
            $('#divanualerning').css('display', 'block');
            var empid = '<%=Session["empid"] %>';
            var data = { 'op': 'get_salaryytd_Details', 'empid': empid };
            var s = function (msg) {
                if (msg) {
                    var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
                    results += '<thead><tr><th scope="col">Sno</th><th scope="col">Employee Name</th><th scope="col">Month</th><th scope="col">Year</th><th scope="col">Gross</th><th scope="col">Total Deduction</th><th scope="col">Net Pay</th><th scope="col"></th></tr></thead></tbody>';
                    var k = 1;
                    var l = 0;
                    var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
                    for (var i = 0; i < msg.length; i++) {
                        results += '<tr style="background-color:' + COLOR[l] + '"><td>' + k++ + '</td>';
                        results += '<th scope="row"  class="1">' + msg[i].empname + '</th>';
                        results += '<td data-title="Code" class="11">' + msg[i].month + '</td>';
                        results += '<td  class="15">' + msg[i].year + '</td>';
                        results += '<td  class="3">' + msg[i].gross + '</td>';
                        results += '<td  class="6">' + msg[i].totaldeduction + '</td>';
                        results += '<td  class="2">' + msg[i].netamount + '</td>';
                        results += '</tr>';
                        l = l + 1;
                        if (l == 4) {
                            l = 0;
                        }
                    }
                    results += '</table></div>';
                    $("#divmnthanuelerning").html(results);
                }
            }
            var e = function (x, h, e) {
                alert(e.toString());
            };
            callHandler(data, s, e);
        }


        function get_pf_Details() {
            $('#div_annualpf').css('display', 'block');
            var empid = '<%=Session["empid"] %>';
            var data = { 'op': 'get_pf_Details', 'empid': empid };
            var s = function (msg) {
                if (msg) {
                    var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
                    results += '<thead><tr><th scope="col" style="text-align:center;">Sno</th><th scope="col" style="text-align:center;">Employee Name</th><th scope="col" style="text-align:center;">Month</th><th scope="col" style="text-align:center;">Year</th><th scope="col" style="text-align:center;">pf</th></tr></thead></tbody>';
                    var k = 1;
                    var l = 0;
                    var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
                    for (var i = 0; i < msg.length; i++) {
                        results += '<tr style="background-color:' + COLOR[l] + '"><td style="text-align:center;">' + k++ + '</td>';
                        results += '<th scope="row"  class="1" style="text-align:center;">' + msg[i].empname + '</th>';
                        results += '<td data-title="Code" class="11" style="text-align:center;">' + msg[i].month + '</td>';
                        results += '<td  class="15" style="text-align:center;">' + msg[i].year + '</td>';
                        results += '<td  class="tammountcls" style="text-align:center;">' + msg[i].pf + '</td>';
                        results += '</tr>';
                        l = l + 1;
                        if (l == 4) {
                            l = 0;
                        }
                    }
                    results += '<tr style="text-align:center;"><th scope="row" class="1" style="text-align:center;"></th>';
                    results += '<td data-title="brandstatus" class="badge bg-yellow" style="text-align:center;">Total</td>';
                    results += '<td data-title="brandstatus" class="6"></td>';
                    results += '<td data-title="brandstatus" class="6"></td>';
                    results += '<td data-title="brandstatus" class="5" style="text-align:center;" ><span id="totalcls" class="badge bg-yellow"></span></td></tr>';
                    results += '</table></div>';
                    $("#divpfmonthely").html(results);
                    GettotalclsCal();
                }
            }
            var e = function (x, h, e) {
                alert(e.toString());
            };
            callHandler(data, s, e);
        }


        function get_incmtax_Details() {
            $('#divanualincmtax').css('display', 'block');
            var empid = '<%=Session["empid"] %>';
            var data = { 'op': 'get_incmtax_Details', 'empid': empid };
            var s = function (msg) {
                if (msg) {
                    var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
                    results += '<thead><tr><th scope="col" style="text-align:center;">Sno</th><th scope="col" style="text-align:center;">Employe Id</th><th scope="col" style="text-align:center;">Employee Name</th><th scope="col" style="text-align:center;">Month</th><th scope="col" style="text-align:center;">Year</th><th scope="col" style="text-align:center;">Total Deduction</th><th scope="col"></th></tr></thead></tbody>';
                    var k = 1;
                    var l = 0;
                    var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
                    for (var i = 0; i < msg.length; i++) {
                        results += '<tr style="background-color:' + COLOR[l] + '"><td class="1" style="text-align:center;">' + k++ + '</td>';
                        results += '<td  class="2" style="text-align:center;">' + msg[i].empid + '</td>';
                        results += '<th scope="row"  class="3" style="text-align:center;">' + msg[i].empname + '</th>';
                        results += '<td data-title="Code" class="4" style="text-align:center;">' + msg[i].month + '</td>';
                        results += '<td  class="5" style="text-align:center;">' + msg[i].year + '</td>';
                        results += '<td  class="it_total" style="text-align:center;">' + msg[i].totaldeduction + '</td>';
                        results += '</tr>';
                        l = l + 1;
                        if (l == 4) {
                            l = 0;
                        }
                    }
                    results += '<tr style="text-align:center;"><th scope="row" class="1" style="text-align:center;"></th>';
                    results += '<td data-title="brandstatus" class="2"></td>';
                    results += '<td data-title="brandstatus" class="badge bg-yellow" style="text-align:center;">Total</td>';
                    results += '<td data-title="brandstatus" class="4"></td>';
                    results += '<td data-title="brandstatus" class="5"></td>';
                    results += '<td data-title="brandstatus" class="6" style="text-align:center;" ><span id="it_totalcls" class="badge bg-yellow"></span></td></tr>';
                    results += '</table></div>';
                    $("#divincmtax").html(results);
                    Gettotal_itclsCal();
                }
            }
            var e = function (x, h, e) {
                alert(e.toString());
            };
            callHandler(data, s, e);
        }


        function CloseClick() {
            $('#divMainAddNewRow').css('display', 'none'); //divpfmainadnewrow
            $('#divempdata').css('display', 'block');
        }
        function aCloseClick() {
            $('#divMainAddNewRow1').css('display', 'none');
            $('#divempdata').css('display', 'block');
            $('#divpfmainadnewrow').css('display', 'none');
            $('#divincmtaxmainrow').css('display', 'none');

        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div id="home-page">
        <div class="home-dashboard">
            <div class="dashboard-tabs">
                <ul class="nav nav-tabs parent">
                    <li data-content="" style="float: left;" class=""><a href="#home-dashboard-0" data-toggle="tab">
                        <i class="icon-rss"></i>Feeds </a></li>
                    <li data-content="" style="float: left;" class=""><a href="#home-dashboard-1" data-toggle="tab">
                        <i class="fa fa-inr" aria-hidden="true"></i>Salary </a></li>
                    <li data-content="" style="float: left;" class="active"><a href="#home-dashboard-2"
                        data-toggle="tab"><i class="fa fa-sitemap" aria-hidden="true"></i>Directory </a>
                    </li>
                </ul>
            </div>
            <div class="tab-content dashboard-container">
                <div class="tab-pane dashboard" id="home-dashboard-0">
                    <style>
                        .feedsTab .user-photo
                        {
                            height: 32px;
                            width: 32px;
                            float: left;
                        }
                        
                        .feedsTab .user-name
                        {
                            color: #053f91;
                            float: left;
                            font-size: 13px;
                            font-weight: bold;
                            margin-left: 1%;
                            padding: 8px;
                        }
                        
                        .feedsTab .feeds-top-bar
                        {
                            border-bottom-style: solid;
                            border-width: thin;
                            color: #aaaaaa;
                            margin-top: 15%;
                        }
                        
                        .feedsTab .feeds
                        {
                            color: #606060;
                            font-size: 18px;
                            margin-top: 9px;
                        }
                        
                        .feedsTab .feeds-refresh
                        {
                            color: #929292;
                        }
                        
                        .feedsTab .feeds-bottom-bar
                        {
                            border-bottom-style: dotted;
                            border-width: thin;
                            color: #ffffff;
                            margin-top: 40px;
                            margin-bottom: 20px;
                        }
                        
                        .feedsTab .group-title
                        {
                            color: #232323;
                            font-size: 15px;
                            padding: 10px 5px 10px 10px;
                            margin-top: 1px;
                        }
                        
                        .feedsTab .post-message
                        {
                            background-color: #ffffff;
                            border-radius: 4px;
                            margin-bottom: 15px;
                            padding: 1.5%;
                            box-shadow: 0px 1px 3px 0px rgba(0, 0, 0, 0.4);
                            -moz-box-shadow: 0px 1px 3px 0px rgba(0, 0, 0, 0.4);
                            -webkit-box-shadow: 0px 1px 3px 0px rgba(0, 0, 0, 0.4);
                        }
                        
                        .feedsTab .update-icon
                        {
                            color: #053f91;
                            font-size: 14px;
                            margin-bottom: 1.5%;
                        }
                        
                        .feedsTab .post-message-form
                        {
                            margin: 0;
                        }
                        
                        .feedsTab .msg-group
                        {
                            margin-bottom: 1%;
                        }
                        
                        .feedsTab .selected-group
                        {
                            color: #75A9F9;
                        }
                        
                        .feedsTab .msg-upload
                        {
                            border-color: #aaaaaa;
                            border-style: dotted;
                            border-width: thin;
                            color: #aaaaaa;
                            height: 22px;
                            margin-right: 1.2%;
                            padding-top: 1.5%;
                            text-align: center;
                            width: 32px;
                        }
                        
                        .feedsTab .attached-group
                        {
                            margin: 0 !important;
                        }
                        
                        .feedsTab .attached-file
                        {
                            border-color: #aaaaaa;
                            border-style: dotted;
                            border-width: thin;
                            color: #aaaaaa;
                            height: 26px;
                            width: auto !important;
                            text-align: center;
                            font-size: 12px;
                            height: 26px;
                            padding: 6px 6px 0 6px;
                        }
                        
                        .feedsTab .remove-attachment
                        {
                            -moz-border-bottom-colors: none;
                            -moz-border-left-colors: none;
                            -moz-border-right-colors: none;
                            -moz-border-top-colors: none;
                            border-color: -moz-use-text-color;
                            border-image: none;
                            border-style: dotted dotted dotted none;
                            border-width: thin thin thin medium;
                            color: #929292;
                            height: 28px;
                            text-align: center;
                            width: 32px;
                            padding-top: 4px;
                            margin-right: 10px;
                        }
                        
                        .feedsTab .file-upload-limit
                        {
                            clear: both;
                            float: left;
                            margin-bottom: 25px;
                            color: #999999;
                        }
                        
                        .feedsTab .msg-info
                        {
                            margin-left: 1.5%;
                        }
                        
                        .feedsTab .delete-attachment
                        {
                            -moz-border-bottom-colors: none;
                            -moz-border-left-colors: none;
                            -moz-border-right-colors: none;
                            -moz-border-top-colors: none;
                            border-color: -moz-use-text-color;
                            border-image: none;
                            border-style: dotted dotted dotted none;
                            border-width: thin thin thin medium;
                            color: #929292;
                            height: 32px;
                            text-align: center;
                            width: 32px;
                        }
                        
                        .feedsTab .btnsubmit
                        {
                            width: 68PX;
                            height: 32px;
                        }
                        
                        .feedsTab .emp-profile-pic
                        {
                            height: 32px;
                            width: 32px;
                        }
                        
                        .feedsTab .msg-fromUser
                        {
                            color: #053f91;
                            font-size: 15px;
                        }
                        
                        .feedsTab .msg-postDate
                        {
                            color: #AAAAAA;
                            font-size: 12px;
                        }
                        
                        .feedsTab .msg-toGroup
                        {
                            font-size: 13px;
                            color: #AAAAAA;
                        }
                        
                        .feedsTab .emp-comment-pic
                        {
                            height: 32px;
                            width: 32px;
                        }
                        
                        .feedsTab .msg-message
                        {
                            clear: both;
                            color: #444444;
                            font-size: 13px;
                            line-height: 1.3em;
                            margin-top: 40px;
                            white-space: pre-line;
                        }
                        
                        .feedsTab .msgLikes
                        {
                            margin-top: 1.5%;
                            clear: both;
                        }
                        
                        .feedsTab .msg-iLiked
                        {
                            color: #4d8df5;
                            font-size: 13px;
                            margin-bottom: 1.5%;
                        }
                        
                        .feedsTab .msg-likeCount
                        {
                            color: #4d8df5;
                            font-size: 13px;
                        }
                        
                        .feedsTab .msg-liked
                        {
                            background-color: #dffcfc;
                            font-size: 14px;
                            height: 28px;
                            padding-top: 8px;
                            text-align: center;
                            width: 36px;
                            color: #2767a6;
                        }
                        
                        .feedsTab .msg-notliked
                        {
                            background-color: #e7e7e7;
                            font-size: 14px;
                            height: 28px;
                            padding-top: 8px;
                            text-align: center;
                            width: 36px;
                            color: #313131;
                        }
                        
                        .feedsTab .comment-area
                        {
                            border: 1px solid #D6D6D6;
                            height: 32px;
                            padding: 1px;
                            width: 500px;
                        }
                        
                        .feedsTab .comment-reply
                        {
                            color: #7a7a7a;
                            font-size: 24px;
                            height: 32px;
                            padding-top: 6px;
                            width: 26px;
                        }
                        
                        .feedsTab .load-more-comments
                        {
                            color: #4d8df5;
                            font-size: 12px;
                            margin-top: 8px;
                        }
                        
                        .feedsTab .comment-list
                        {
                            border-bottom: thin dashed;
                            border-color: #d6d6d6;
                            margin-bottom: 10px;
                            margin-left: 9%;
                            margin-top: 8px;
                            padding-bottom: 10px;
                        }
                        
                        .feedsTab .comment-name
                        {
                            color: #053f91;
                            float: left;
                            font-size: 13px;
                            margin-left: 1%;
                        }
                        
                        .feedsTab .comment-date
                        {
                            color: #aaaaaa;
                            font-size: 12px;
                        }
                        
                        .feedsTab .msg-list
                        {
                            clear: both;
                            background-color: #ffffff;
                            border-radius: 4px;
                            padding: 1.5%;
                            margin-bottom: 15px;
                            box-shadow: 0px 1px 3px 0px rgba(0, 0, 0, 0.4);
                            -moz-box-shadow: 0px 1px 3px 0px rgba(0, 0, 0, 0.4);
                            -webkit-box-shadow: 0px 1px 3px 0px rgba(0, 0, 0, 0.4);
                        }
                        
                        .feedsTab .comment-info
                        {
                            margin-left: 1.5%;
                            margin-bottom: 5px;
                        }
                        
                        .feedsTab .comment-info
                        {
                            margin-left: 1.5%;
                            margin-bottom: 5px;
                        }
                        
                        .feedsTab .attach
                        {
                            display: none;
                        }
                        
                        .feedsTab .msg-file
                        {
                            margin-top: 1.5%;
                        }
                        
                        .feedsTab .file-image
                        {
                            clear: both;
                            margin-bottom: 1.5%;
                            position: relative;
                            max-height: 300px;
                            overflow: hidden;
                            width: 100%;
                            cursor: pointer;
                        }
                        
                        .feedsTab .image-gallery
                        {
                            clear: both;
                        }
                        
                        .feedsTab .image-gallery-spotlight
                        {
                            clear: both;
                            cursor: pointer;
                            display: inline-block;
                            height: 248px;
                            list-style: outside none none;
                            overflow: hidden;
                            position: relative;
                            vertical-align: bottom;
                            width: 100%;
                        }
                        
                        .feedsTab .image-gallery-spotlight img
                        {
                            left: 50%;
                            position: absolute;
                            top: 50%;
                            -webkit-transform: translate(-50%, -50%);
                            -ms-transform: translate(-50%, -50%);
                            -moz-transform: translate(-50%, -50%);
                        }
                        
                        .feedsTab .image-gallery-spotlight-for-three
                        {
                            clear: both;
                            cursor: pointer;
                            display: inline-block;
                            height: 122px;
                            list-style: outside none none;
                            overflow: hidden;
                            position: relative;
                            width: 100%;
                        }
                        
                        .feedsTab .image-gallery-spotlight-for-three img
                        {
                            left: 50%;
                            position: absolute;
                            top: 50%;
                            -webkit-transform: translate(-50%, -50%);
                            -ms-transform: translate(-50%, -50%);
                            -moz-transform: translate(-50%, -50%);
                        }
                        
                        .feedsTab .actual-image
                        {
                            clear: both;
                            margin-bottom: 1.5%;
                            position: relative;
                            overflow: hidden;
                            cursor: pointer;
                        }
                        
                        .feedsTab .actual-image img
                        {
                            height: auto;
                            margin-bottom: 1.5%;
                        }
                        
                        .feedsTab .closeSliderModal
                        {
                            font-size: 14px;
                            margin-right: 12px;
                            cursor: pointer;
                            padding-top: 6px;
                            color: #aaaaaa;
                        }
                        
                        .feedsTab .carousel-control
                        {
                            top: 50%;
                            background: #222222 none repeat scroll 0 0;
                            font-size: 30px;
                            color: #ffffff;
                            border: 0;
                        }
                        
                        .feedsTab .card-image
                        {
                            clear: both;
                            margin-bottom: 1.5%;
                        }
                        
                        .feedsTab .card-image img
                        {
                            height: auto;
                            width: 100%;
                            margin-bottom: 1.5%;
                        }
                        
                        .feedsTab .file-image img
                        {
                            height: auto;
                            width: 100%;
                            margin-bottom: 1.5%;
                        }
                        
                        .feedsTab .total-img-count
                        {
                            padding: 18px 14px 6px;
                            background: rgba(0, 0, 0, 0.5);
                            width: 30px;
                            color: #fff;
                            position: absolute;
                            height: 30px;
                            float: right;
                            right: 0;
                            vertical-align: bottom;
                        }
                        
                        .feedsTab .total-img-count
                        {
                            color: #FFFFFF;
                            font-size: 20px;
                        }
                        
                        .feedsTab .comment-msg
                        {
                            clear: both;
                            color: #606060;
                            font-size: 13px;
                            line-height: 1.3em;
                            padding-top: 6px;
                            white-space: pre-line;
                        }
                        
                        .feedsTab .msg-like
                        {
                            color: #2343ba;
                            margin-left: 2%;
                            margin-top: 2%;
                        }
                        .feedsTab .msg-like-count
                        {
                            background-color: #DFEDD6;
                            font-size: 14px;
                            height: 28px;
                            padding-top: 8px;
                            text-align: center;
                            width: 32px;
                            color: #355723;
                        }
                        
                        .feedsTab .msg-more
                        {
                            margin-left: 5px;
                        }
                        
                        .feedsTab .msg-comment
                        {
                            clear: both;
                            margin-top: 1%;
                            display: flex;
                        }
                        
                        .feedsTab .groupsTable
                        {
                            color: #0C59CF;
                            font-size: 16px;
                            margin-top: 5px;
                        }
                        
                        .feedsTab .groupsTable td
                        {
                            padding: 10px;
                        }
                        
                        .feedsTab .text-center
                        {
                            text-align: center !important;
                        }
                        
                        .feedsTab .groupTable
                        {
                            border-collapse: unset;
                            border-spacing: 1px;
                        }
                        .feedsTab .group-background
                        {
                            background-color: rgba(255, 255, 255, 0.36);
                        }
                        .feedsTab .outer-div
                        {
                            overflow: hidden;
                        }
                        
                        .quickLinksHeader
                        {
                            background-color: #ffffff;
                            color: #3f494b;
                            font-size: 14px;
                            margin: 0px 20px 1px 0px;
                            padding: 10px;
                        }
                        .feedsTab .quickLinks
                        {
                            font-size: 14px;
                            background-color: #ffffff;
                            padding: 5px 0px 0px 10px;
                            margin-right: 20px;
                        }
                        
                        .feedsTab .aQuickLink
                        {
                            color: #7A7A7A !important;
                            text-decoration: underline;
                        }
                        
                        .feedsTab .quickLinks:last-child
                        {
                            padding-bottom: 10px;
                        }
                        
                        .feedsTab .activitiesAccordion
                        {
                            margin: 0px 20px 20px 0px;
                        }
                        
                        .feedsTab .accordion-heading
                        {
                            background-color: #ffffff;
                        }
                        .feedsTab .accordion-body
                        {
                            background-color: #E0F0FC;
                        }
                        .feedsTab .accordion-group
                        {
                            border: 0px;
                            border-bottom: 0px solid #e5e5e5;
                        }
                        .feedsTab accordionIcons
                        {
                            color: #3F494B;
                            opacity: 0.49;
                            font-size: 12px;
                        }
                        .feedsTab .accordionHeadingFont
                        {
                            color: #3F494B;
                            font-size: 14px;
                        }
                        
                        .feedsTab .sub-title
                        {
                            color: #929292;
                            font-size: 12px;
                            margin-top: 12px;
                        }
                        .feedsTab .accordion-data
                        {
                            color: #3F494B;
                            font-size: 14px;
                        }
                        .feedsTab .accordion-inner
                        {
                            padding: 0 15px 10px;
                            border: none;
                        }
                        .feedsTab .likesCount
                        {
                            margin-top: 1.5%;
                        }
                        .feedsTab .revList
                        {
                            margin-top: 12px;
                        }
                        .feedsTab .trkList
                        {
                            margin-top: 12px;
                        }
                        .feedsTab .no-feed-title
                        {
                            color: #606060;
                            font-size: 20px;
                            line-height: 1.3em;
                            text-align: center;
                        }
                        .feedsTab .no-feed-description
                        {
                            color: #606060;
                            font-size: 16px;
                            line-height: 1.3em;
                            text-align: center;
                        }
                        .feedsTab .vireMore
                        {
                            text-align: right;
                            margin-top: 5px;
                        }
                        
                        .feedsTab .default-feed img
                        {
                            height: auto;
                            width: 100%;
                        }
                        
                        .feedsTab .feeds-info-content
                        {
                            font-size: 14px;
                            line-height: 1.5em;
                        }
                        
                        .feedsTab .personalDetailsModal
                        {
                            width: 500px;
                        }
                        
                        .feedsTab .msg-upload input
                        {
                            display: none;
                        }
                        .feedsTab .msg-upload i
                        {
                            display: inline;
                        }
                        
                        :root .feedsTab .msg-upload
                        {
                            display: inline-block\9;
                            width: 150px\9;
                            border: none\9;
                        }
                        .ie10 .feedsTab .msg-upload
                        {
                            display: inline-block;
                            width: 150px;
                            border: none;
                        }
                        
                        :root .feedsTab .msg-upload i
                        {
                            display: none\9;
                        }
                        .ie10 .feedsTab .msg-upload i
                        {
                            display: none;
                        }
                        
                        :root .feedsTab .msg-upload input
                        {
                            display: inline\9;
                        }
                        .ie10 .feedsTab .msg-upload input
                        {
                            display: inline;
                        }
                    </style>
                    <div id="feeds" class="feedsTab row-fluid">
                        <div class="feed">
                            <div id="feedsInfoModal" class="modal hide" tabindex="-1" role="dialog">
                                <div class="modal-header">
                                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                                        <i class="icon-remove"></i>
                                    </button>
                                    <h3>
                                    </h3>
                                </div>
                                <div class="modal-body">
                                    <div class="feeds-info-content">
                                    </div>
                                </div>
                            </div>
                            <div id="personalDetailsModal" class="personalDetailsModal modal hide" tabindex="-1"
                                role="dialog" style="display: none;">
                                <div class="modal-header">
                                    <h3>
                                        Help us to know you better</h3>
                                </div>
                                <form name="personalDetailsForm" class="personalDetailsForm" method="POST" novalidate="novalidate">
                                </form>
                            </div>
                            <div class="span3" style="margin-left: 20px;">
                                <div class="user-details">
                                    <div class="user-photo" id="feedsUserPhoto">
                                        <img id="imguser" class="img"></div>
                                    <div class="user-name">
                                        <label id="lbluname">
                                        </label>
                                    </div>
                                </div>
                                <div class="feeds-bottom-bar">
                                </div>
                                <table class="groupTable">
                                    <tbody>
                                        <tr id="1" text="Everyone">
                                            <td class="group-title group-background" style="width: 100%; background-color: #ffffff;
                                                cursor: pointer;">
                                                All Feeds
                                            </td>
                                            <td style="padding: 0px;">
                                            </td>
                                            <td class="group-title group-background" style="padding: 10px; background-color: #ffffff;">
                                                <span class="text-center feeds-refresh" data-toggle="tooltip" data-original-title="Refresh"
                                                    style="cursor: pointer;"><i class="icon-refresh"></i></span>
                                            </td>
                                        </tr>
                                        <tr id="2" text="Events">
                                            <td class="group-title group-background" colspan="3" style="cursor: pointer;">
                                                <span onclick="spnevents(this);"><i class="fa fa-calendar-o" aria-hidden="true"></i>
                                                    Events</span>
                                            </td>
                                        </tr>
                                        <tr id="3" text="Company News">
                                            <td class="group-title group-background" colspan="3" style="cursor: pointer;">
                                                <span onclick="spncmpnews();"><i class="fa fa-newspaper-o" aria-hidden="true"></i>Company
                                                    News</span>
                                            </td>
                                        </tr>
                                        <tr id="4" text="Appreciations">
                                            <td class="group-title group-background" colspan="3" style="cursor: pointer;">
                                                <span onclick="spnapritiations();">Appreciations</span>
                                            </td>
                                        </tr>
                                        <%--<tr id="5" text="Buy/Sell/Rent">
                                            <td class="group-title group-background" colspan="3" style="cursor: pointer;">
                                                <span onclick="spnbsr();">Buy/Sell/Rent</span>
                                            </td>
                                        </tr>--%>
                                    </tbody>
                                </table>
                            </div>
                            <div class="span6" style="margin-left: 20px; background-color: White;">
                                <table id="tbl_new_employee_list" align="center">
                                </table>
                            </div>
                            <div id="loadAllMsgLikesModal" class="modal hide loadAllMsgLikesModal" tabindex="-1"
                                role="dialog">
                                <div class="modal-header">
                                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                                        <i class="icon-remove"></i>
                                    </button>
                                    <h3 id="myModalLabel">
                                        People Who Like This Message</h3>
                                </div>
                                <div class="modal-body">
                                    <table class="allLikesTable">
                                        <tbody>
                                            <script id="loadAllLikersList_data_xtemplate" type="text/x-jsrender" data-jsv-tmpl="loadAllLikersList_data_template">
						{{for allLikersList}}
						<tr id='{{:userId}}'>
						  <td>
							 <div  style="padding-top:10px;margin-left: 6px;padding-bottom: 45px;width: 500px; border-bottom: 1px dotted #d6d6d6;">	       
						       <div class="emp-comment-pic pull-left">
								 <img src="{{:url}}" class="es-employee-photo img_left pull-left"> 
								</div>
								<div class="comment-info">
									<div class="comment-name">{{:name}}</div>
								</div>
							</div>
						  </td>
						</tr>
						{{/for}}
                                            </script>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- panel-content -->
                    <div class="panel-footer">
                    </div>
                    <!-- panel -->
                </div>
                <!-- dashboard 0 ends -->
                <div class="tab-pane dashboard" id="home-dashboard-1">
                    <header>
                    </header>
                    <section>
                        <a class="prev browse left"></a>
                        <div class="emp-home-dashboard home-dashboard-epayroll">
                            <div class="items">
                                <div class="row-fluid">
                                    <div class="panel-wrapper span4">
                                        <div id="divempdata" class="panel">
                                            <div class="panel-content">
                                                <div class="panel-header">
                                                    <h4>
                                                        Payslip</h4>
                                                </div>
                                                <h5>
                                                    <label id="lblmonth">
                                                    </label>
                                                </h5>
                                                <table class="table-condensed table-striped" style="width: 100%;">
                                                    <tbody>
                                                        <tr>
                                                            <td>
                                                                Gross Pay
                                                            </td>
                                                            <td class="right">
                                                                <label id="lblgrosspay">
                                                                </label>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                Deductions
                                                            </td>
                                                            <td class="right">
                                                                <label id="lbldeduction"></label>
                                                            </td>
                                                        </tr>
                                                        <tr class="footer">
                                                            <td>
                                                                Net Pay
                                                            </td>
                                                            <td class="right">
                                                                <label id="lblnetpay"></label>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </div>
                                            <!-- panel-content -->
                                            <div class="panel-footer">
               <a ><input id="btn_save" type="button" class="btn btn-primary btn-block" name="submit" value="View PaySlip" onclick="viewpayslipclick();" /></a>
                                              <%-- View Payslips</a>--%>
                                            </div>
                                        </div>
                                        <!-- panel -->
                                    </div>
                                    <div id="divMainAddNewRow" class="pickupclass" style="text-align: center; height: 100%;
            width: 100%; position: absolute; display: none; left: 0%; top: 0%; z-index: 99999;
            background: rgba(192, 192, 192, 0.7);">
            <div id="divAddNewRow" style="border: 5px solid #A0A0A0; position: absolute; top: 8%;
                background-color: White; left: 10%; right: 10%; width: 80%; height: 100%; -webkit-box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65);
                -moz-box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65); box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65);
                border-radius: 10px 10px 10px 10px;">
                  <div id="divpayslips" class="box box-primary" style="display:none;">
            <div class="box-body box-profile" style="text-align: left;width: 68%;padding-left: 30%;">
              <ul class="list-group list-group-unbordered">
                <li class="list-group-item">
                  <b>Gross Pay</b> <a class="pull-right"><label id="lblpgrosspay"></label></a>
                </li>
                <li class="list-group-item">
                  <b>Basic</b> <a class="pull-right"><label id="lblpbasic"></label></a>
                </li>
                <li class="list-group-item">
                  <b>HRA</b> <a class="pull-right"><label id="lblphra"></label></a>
                </li>
                <li class="list-group-item">
                  <b>Conveyance</b> <a class="pull-right"><label id="lblpconve"></label></a>
                </li>
                <li class="list-group-item">
                  <b>Medical Allowance</b> <a class="pull-right"><label id="lblpmedical"></label></a>
                </li>
                <li class="list-group-item">
                  <b>Washing Allowance</b> <a class="pull-right"><label id="lblpwashing"></label></a>
                </li>
                <li class="list-group-item">
                  <b>PT</b> <a class="pull-right"><label id="lblppt"></label></a>  
                </li>
                <li class="list-group-item">
                  <b>PF</b> <a class="pull-right"><label id="lblppf"></label></a>  
                </li>
                <li class="list-group-item">
                  <b>ESI</b> <a class="pull-right"><label id="lblesi"></label></a>  
                </li>
                <li class="list-group-item">
                  <b>Salary Advance</b> <a class="pull-right"><label id="lblSalryadvance"></label></a>  
                </li>
                 <li class="list-group-item">
                  <b>Loan Deduction</b> <a class="pull-right"><label id="lblLoan"></label></a>  
                </li>
                 <li class="list-group-item">
                  <b>Canteen Deduction</b> <a class="pull-right"><label id="lblcanteen"></label></a>  
                </li>
                <li class="list-group-item">
                  <b>Mobile Deduction</b> <a class="pull-right"><label id="lblmbl"></label></a>  
                </li>
                 <li class="list-group-item">
                  <b>Mediclaim Deduction</b> <a class="pull-right"><label id="lblmedicliam"></label></a>  
                </li>
                 <li class="list-group-item">
                  <b>TDS Deduction</b> <a class="pull-right"><label id="lbltds"></label></a>  
                </li>
                 <li class="list-group-item">
                  <b>Other Deduction</b> <a class="pull-right"><label id="lblotherdedu"></label></a>  
                </li>
                <li class="list-group-item">
                  <b>Deductions</b> <a class="pull-right"><label id="lblpdeduction"></label></a>
                </li>
                <li class="list-group-item">
                  <b>NetPay</b> <a class="pull-right"><label id="lblpnetpay"></label></a>
                </li>
              </ul>
            </div>
            <!-- /.box-body -->
          </div>
            </div>
            <div id="divclose" style="width: 35px; top: 7.5%; right: 8%; position: absolute;
                z-index: 99999; cursor: pointer;">
                <img src="Images/Close.png" alt="close" onclick="CloseClick();" />
            </div>
        </div>
                                    <div class="panel-wrapper span4">
                                        <div class="panel">
                                            <div class="panel-content">
                                                <div class="panel-header">
                                                    <h4>
                                                        Annual Earnings</h4>
                                                </div>
                                                <h5>
                                                    (2017 - 2018)</h5>
                                                <table class="table-condensed table-striped" style="width: 100%;">
                                                    <tbody>
                                                        <tr>
                                                            <td>
                                                                Gross Pay
                                                            </td>
                                                            <td class="right">
                                                                <label id="lblagrosspay">
                                                                </label>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                Deductions
                                                            </td>
                                                            <td class="right">
                                                                <label id="lbladeduction">
                                                                </label>
                                                            </td>
                                                        </tr>
                                                        <tr class="footer">
                                                            <td>
                                                                Net Pay
                                                            </td>
                                                            <td class="right">
                                                                <label id="lblanetpay">
                                                                </label>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </div>
                                            <!-- panel-content -->
                                           <div class="panel-footer">
               <a ><input id="Button1" type="button" class="btn btn-primary btn-block" name="submit" value="View YTD" onclick="viewanualerning();" /></a>
                                              <%-- View Payslips</a>--%>
                                            </div>
                                        </div>
                                        <!-- panel -->
                                    </div>

                                    <div id="divMainAddNewRow1" class="pickupclass" style="text-align: center; height: 100%;
            width: 100%; position: absolute; display: none; left: 0%; top: 0%; z-index: 99999;
            background: rgba(192, 192, 192, 0.7);">
            <div id="div2" style="border: 5px solid #A0A0A0; position: absolute; top: 8%;
                background-color: White; left: 10%; right: 10%; width: 80%; height: 100%; -webkit-box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65);
                -moz-box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65); box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65);
                border-radius: 10px 10px 10px 10px;">
                  <div id="divanualerning" class="box box-primary" style="display:none;">
            <div class="box-body box-profile" style="text-align: left;">
              <div id="divmnthanuelerning"></div>
            </div>
            <!-- /.box-body -->
          </div>
            </div>
            <div id="div4" style="width: 35px; top: 7.5%; right: 8%; position: absolute;
                z-index: 99999; cursor: pointer;">
                <img src="Images/Close.png" alt="close" onclick="aCloseClick();" />
            </div>
        </div>


                                    <div class="panel-wrapper span4">
                                        <div class="panel">
                                            <div class="panel-content">
                                                <div class="panel-header">
                                                    <h4>
                                                        Income Tax
                                                        <br>
                                                        &nbsp;</h4>
                                                </div>
                                                <table class="table-condensed table-striped" style="width: 100%;">
                                                    <tbody>
                                                        <tr>
                                                            <td>
                                                                Annual Taxable Income
                                                            </td>
                                                            <td class="right">
                                                                <label id="lblitpay">
                                                                </label>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                Income Tax
                                                            </td>
                                                            <td class="right">
                                                                <label id="lbl_itax">
                                                                </label>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                Tax Paid Till Date
                                                            </td>
                                                            <td class="right">
                                                                <label id="lbl_txpaid">
                                                                </label>
                                                            </td>
                                                        </tr>
                                                        <tr class="footer">
                                                            <td>
                                                                Balance To Pay
                                                            </td>
                                                            <td class="right">
                                                                <label id="lbl_totpay">
                                                                </label>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </div>
                                            <!-- panel-content -->
                                            <div class="panel-footer">
                                           <a ><input id="Button3" type="button" class="btn btn-primary btn-block" name="submit" value="View YTD" onclick="viewanualinmtax();" /></a>
                                              <%-- View Payslips</a>--%>
                                            </div>
                                            <div id="divincmtaxmainrow" class="pickupclass" style="text-align: center; height: 100%;
            width: 100%; position: absolute; display: none; left: 0%; top: 0%; z-index: 99999;
            background: rgba(192, 192, 192, 0.7);">
            <div id="div5" style="border: 5px solid #A0A0A0; position: absolute; top: 8%;
                background-color: White; left: 10%; right: 10%; width: 80%; height: 100%; -webkit-box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65);
                -moz-box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65); box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65);
                border-radius: 10px 10px 10px 10px;">
                  <div id="divanualincmtax" class="box box-primary" style="display:none;">
            <div class="box-body box-profile" style="text-align: left;">
              <div id="divincmtax"></div>
            </div>
            <!-- /.box-body -->
          </div>
            </div>
            <div id="div9" style="width: 35px; top: 7.5%; right: 8%; position: absolute;
                z-index: 99999; cursor: pointer;">
                <img src="Images/Close.png" alt="close" onclick="aCloseClick();" />
                 </div>
                       </div>
                                        </div>
                                        <!-- panel -->
                                    </div>
                                </div>
                                <div class="row-fluid">
                                    <div class="panel-wrapper span4">
                                        <div class="panel">
                                            <div class="panel-content">
                                                <div class="panel-header">
                                                    <h4>
                                                        Annual PF Savings</h4>
                                                </div>
                                                <h5>
                                                    (2016 - 2017)</h5>
                                                <hr>
                                           <table class="table-condensed table-striped" style="width: 100%;">
                                                    <tbody>
                                                        <tr class="footer">
                                                            <td>
                                                                Annual Pf
                                                            </td>
                                                            <td class="right">
                                                                <label id="lbl_pf">
                                                                </label>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                                </div>
                                            <div class="panel-footer">
                                           <a ><input id="Button2" type="button" class="btn btn-primary btn-block" name="submit" value="View Pf" onclick="viewanualpf();" /></a>
                                              <%-- View Payslips</a>--%>
                                            </div>
                                                <div>
                                                (Employee &amp; Employer Contribution)
                                            </div>
                                            <!-- panel-content -->
                                        </div>
                                        <!-- panel -->
                                    </div>
                                </div>
            <div id="divpfmainadnewrow" class="pickupclass" style="text-align: center; height: 100%;
            width: 100%; position: absolute; display: none; left: 0%; top: 0%; z-index: 99999;
            background: rgba(192, 192, 192, 0.7);">
            <div id="div3" style="border: 5px solid #A0A0A0; position: absolute; top: 8%;
                background-color: White; left: 10%; right: 10%; width: 80%; height: 100%; -webkit-box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65);
                -moz-box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65); box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65);
                border-radius: 10px 10px 10px 10px;">
                  <div id="div_annualpf" class="box box-primary" style="display:none;">
            <div class="box-body box-profile" style="text-align: left;">
              <div id="divpfmonthely"></div>
            </div>
            <!-- /.box-body -->
          </div>
            </div>
            <div id="div7" style="width: 35px; top: 7.5%; right: 8%; position: absolute;
                z-index: 99999; cursor: pointer;">
                <img src="Images/Close.png" alt="close" onclick="aCloseClick();" />
            </div>
        </div>
                            </div>
                            <a class="next browse right"></a>
                        </div>
                    </section>
                </div>
                <!-- dashboard 1 ends -->
                <div class="tab-pane dashboard active" id="home-dashboard-2">
                    <div class="pad main directoryTab">
                        <div class="row-fluid dir" id="directory">
                            <div class="span6">
                                <div class="tab-panel directoryTable">
                                    <ul class="nav nav-tabs" style="padding-top: 0px; background-color: #fff;">
                                        <li class="active"><a class="everyone active" data-toggle="tab" href=".everyone"><i
                                            class="fa fa-user" aria-hidden="true"></i>Everyone</a></li>
                                    </ul>
                                </div>
                                <div class="head searchEveryonePanel">
                                    <div class="row-fluid">
                                        <div class="span6">
                                            <div class="right-inner-addon">
                                                <i class="icon-search"></i>
                                                <input id="selct_employe" class="search searchEveryone" type="search" placeholder="Search">
                                            </div>
                                            <div style="height: 40px; display: none">
                                                <input id="txtsupid" type="hidden" class="form-control" name="hiddenempid" />
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="head searchMyTeamPanel" style="display: none;">
                                    <div class="row-fluid">
                                        <div class="span6">
                                            <div class="right-inner-addon">
                                                <i class="icon-search"></i>
                                                <input class="search searchMyTeam" type="search" placeholder="Search" />
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div id="div_Employeedata" class="leftpanel everyonePanel">
                                </div>
                                <div class="leftpanel myTeamPanel" style="display: none;">
                                    <table class="directoryTable myTeamTable table-hover">
                                        <tbody>
                                            <script id="myTeamEmpList_data_xtemplate" type="text/x-jsrender" data-jsv-tmpl="myTeamEmpList_template">
							{{for myTeamEmpList}}
							<tr guid='{{:guid}}' id='{{:id}}' class ="row-style">
								<td style="width:45px"><img src="{{:url}}" class="img-small"></td>
								<td class="emp-directory"><span style="text-transform: uppercase;">{{:name}} [{{:empno}}]</span>
									<br><div class="small muted"><span style="text-transform: capitalize;">{{:designation}}</span></div>
								</td>
								<td class="right small muted underline email-padding" ><a href="mailto:{{:email}}" target="_top">{{:email}}</a><br></td>				
							</tr>
							{{/for}}			   		
                                            </script>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                            <div class="span5 rightpanel" style="display: block;">
                                <div class="padding-top text-center">
                                    <div class="empPhoto">
                                        <img id="img1" class="img-circle"></div>
                                </div>
                                <div class="padding-top text-center">
                                    <div class="emp-directory">
                                        <h4 class="nametd">
                                            <label id="lblname">
                                            </label>
                                        </h4>
                                    </div>
                                    <div class="destd">
                                    </div>
                                    <div class="empno" style="color: #5F5F5F">
                                        <label id="lblcode">
                                        </label>
                                    </div>
                                </div>
                                <div class="padding-top">
                                    <table class="detailTable" style="width: 100%;">
                                        <tbody>
                                            <tr>
                                                <td class="stl muted">
                                                    Email :
                                                </td>
                                                <td class="emp-directory">
                                                    <label id="lblemail">
                                                    </label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="stl muted">
                                                    Contact No :
                                                </td>
                                                <td class="emp-directory">
                                                    <label id="lblcontact">
                                                    </label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="stl muted"> 
                                                    Join Date:
                                                </td>
                                                <td class="emp-directory">
                                                    <label id="lbljoindate">
                                                    </label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="stl muted">
                                                    Location:
                                                </td>
                                                <td class="emp-directory">
                                                    <label id="lbllocation">
                                                    </label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="stl muted">
                                                    Designation:
                                                </td>
                                                <td class="emp-directory">
                                                    <label id="lblrole">
                                                    </label>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- dashboard 2 ends -->
            </div>
        </div>
        <div id="mobileAppAddModel" class="mobileAppAddModel modal hide" tabindex="-1" role="dialog"
            style="width: 600px; background-image: url('images/home/greythrAppPopup.png');">
            <div class="row-fluid">
                <div class="span11">
                </div>
                <div class="span1" style="padding-top: 10px; padding-left: 5px;">
                    <span class="icon-remove mobileAppRemindLater" style="color: #ffffff;"></span>
                </div>
            </div>
            <form name="mobileAppAddForm" class="mobileAppAddForm" style="margin: 0px;" novalidate="novalidate">
            <div class="footer" style="padding-top: 180px;">
                <div class="row-fluid">
                    <div class="span5">
                    </div>
                    <div class="span5">
                        <input id="mobileno" value="" type="text" class="mobileno input-large" name="mobileno"
                            placeholder="Mobile No">
                    </div>
                    <div class="span2 pull-right">
                        <span class="btn btn-primary getLinkForApp" style="color: #ffffff;">Get Link</span>
                    </div>
                </div>
                <div class="row-fluid">
                    <div class="span9">
                    </div>
                    <div class="span3 pull-right">
                        <span class="mobileAppNotRelevant" style="color: #ffffff;">Not Relevant for me</span>
                    </div>
                </div>
            </div>
            </form>
        </div>
    </div>
    <div id="divpayslip" style="display: none;">
        <table class="table table-bordered table-info table-condensed">
            <tbody>
                <tr>
                    <td class="heading">
                        Employee No
                    </td>
                    <td class="data">
                        <label id="lblpempno">
                        </label>
                    </td>
                    <td class="heading">
                        Name
                    </td>
                    <td class="data">
                        <label id="lblpname">
                        </label>
                    </td>
                </tr>
                <tr>
                    <td class="heading">
                        Bank
                    </td>
                    <td class="data">
                        <label id="lblpbank">
                        </label>
                    </td>
                    <td class="heading">
                        Bank Account No
                    </td>
                    <td class="data">
                        <label id="lblpbankaccountno">
                        </label>
                    </td>
                </tr>
                <tr>
                    <td class="heading">
                        Joining Date
                    </td>
                    <td class="data">
                        <label id="lblpjod">
                        </label>
                    </td>
                    <td class="heading">
                        PF No
                    </td>
                    <td class="data">
                        <label id="lblppfno">
                        </label>
                    </td>
                </tr>
            </tbody>
        </table>
        <table id="tblPayslipData" class="table table-bordered table-striped table-info">
            <tbody>
                <tr class="header">
                    <th class="td-33">
                        Earnings
                    </th>
                    <th class="right td-17">
                        Rs.
                    </th>
                    <th class="td-33">
                        Deductions
                    </th>
                    <th class="right td-17">
                        Rs.
                    </th>
                </tr>
                <tr>
                    <td>
                        BASIC
                    </td>
                    <td class="right">
                        <label id="lblpbasic">
                        </label>
                    </td>
                    <td>
                        PROF TAX
                    </td>
                    <td class="right">
                        <label id="Label1">
                        </label>
                        183.00
                    </td>
                </tr>
                <tr>
                    <td>
                        HRA
                    </td>
                    <td class="right">
                        <label id="Label2">
                        </label>
                        8650.00
                    </td>
                    <td>
                        CANTEEN DEDUCTION
                    </td>
                    <td class="right">
                        <label id="Label3">
                        </label>
                        510.00
                    </td>
                </tr>
                <tr>
                    <td>
                        CONVEYANCE ALLOWANCE
                    </td>
                    <td class="right">
                        <label id="Label4">
                        </label>
                        1600.00
                    </td>
                    <td>
                        MOBILE DEDUCTION
                    </td>
                    <td class="right">
                        783.32
                    </td>
                </tr>
                <tr>
                    <td>
                        MEDICAL ALLOWANCE
                    </td>
                    <td class="right">
                        1250.00
                    </td>
                    <td>
                        MEDICAL INSURANCE PREMIUM
                    </td>
                    <td class="right">
                        442.00
                    </td>
                </tr>
                <tr>
                    <td>
                        WASHING ALLOWANCE
                    </td>
                    <td class="right">
                        1000.00
                    </td>
                    <td>
                        &nbsp;
                    </td>
                    <td>
                        &nbsp;
                    </td>
                </tr>
                <tr>
                    <td>
                        <b>Total Earnings</b>
                    </td>
                    <td class="right">
                        <b>25000.00</b>
                    </td>
                    <td>
                        <b>Total Deductions</b>
                    </td>
                    <td class="right">
                        <b>1918.00</b>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
</asp:Content>
