define(["cilantro/define/viewelement"],function(a){var b=['<option selected id="<%=this.field_id%>" value="range">is between</option>','<option id="<%=this.field_id%>" value="-range">is not between</option>','<option id="<%=this.field_id%>" value="lt">is less than</option>','<option id="<%=this.field_id%>" value="gt">is greater than</option>','<option id="<%=this.field_id%>" value="lte">is less than or equal to</option>','<option id="<%=this.field_id%>" value="gte">is greater than or equal to</option>','<option id="<%=this.field_id%>" value="exact">is equal to</option>','<option id="<%=this.field_id%>" value="-exact">is not equal to</option>','<option id="<%=this.field_id%>" value="isnull">is null</option>','<option id="<%=this.field_id%>" value="-isnull">is not null</option>'],c=['<option selected value="in">is equal to</option>','<option value="-in">is not equal to</option>'],d=['<option selected value="iexact">is equal to</option>','<option value="-iexact">is not equal to</option>','<option value="in">is one of</option>','<option value="-in">is not one of</option>','<option value="icontains">contains</option>','<option value="-icontains">does not contain</option>'],e=a.extend({constructor:function(a,b){this.base(a,b),$('input[data-validate="date"]',this.dom).datepicker({changeMonth:!0,changeYear:!0})},render:function(){var a={nullboolean:e.nullboolean_tmpl,"boolean":e.boolean_tmpl,date:e.number_tmpl,number:e.number_tmpl,string:e.string_tmpl,"string-list":e.stringlist_tmpl},b=this.dom=$('<span class="form_container"></span>'),c=this.concept_pk;$.each(this.viewset.fields,function(d,f){var g=[a[f.datatype]];g.unshift($.jqotec("<p>")),g.push($.jqotec("</p>")),f.hasOwnProperty("pk")||g.push(e.pk_tmpl),$.each(["choices","pkchoices"],function(a,b){f[b]&&$.each(f[b],function(a,c){f[b][a][0]===null&&(f[b][a][0]="null"),f[b][a][1]==="None"&&(f[b][a][1]="No Data")})});var h=null,i=null;if(f.hasOwnProperty("pk"))h=c+"_"+f.pk;else{var j=$.map(f.pkchoices,function(a,b){return parseInt(a[0])});j.sort(),i=j.join("OR"),h=c+"_"+i}var k=$($.jqote(g,{datatype:f.datatype,choices:f.choices,field_id:h,label:f.name,pkchoices:f.pkchoices,pkchoice_label:f.pkchoice_label,pkchoice_id:i,optional:f.hasOwnProperty("optional")?f.optional:!1,"default":f.hasOwnProperty("default")?f["default"]:0,pkchoice_default:f.hasOwnProperty("pkchoice_default")?f.pkchoice_default:0}));k.children().not("span").wrap("<span/>"),b.append(k)})},elementChanged:function(a){var b=$(a.target);if($.contains(this.dom.get(0),b.get(0))){var c,d,f=this.dom,g=this;switch(a.target.type){case"checkbox":c=a.target.checked,c=b.is(":visible")&&b.is(":enabled")?c:undefined,f.trigger("ElementChangedEvent",[{name:a.target.name,value:c}]);break;case"select-one":case"select-multiple":case"select":var h=[],i=null,j=e.opRe.exec(b.attr("name"));j&&(i=$("[name^="+j[1]+"_"+j[2]+"]",f).not(b).not("span")),$("option",$(a.target)).each(function(a,b){if(b.selected){h.push(b.value);var c={decimal:1,number:1,date:1};if(i&&i.attr("data-validate")in c)b.value.search(/range/)<0?b.value.search(/null/)<0?($("input[name="+b.id+"_input1],",f).hide().change(),$("label[for="+b.id+"_input1]",f).hide(),$("input[name="+b.id+"_input0]",f).show().change()):($("input[name="+b.id+"_input1],",f).hide().change(),$("label[for="+b.id+"_input1]",f).hide(),$("input[name="+b.id+"_input0]",f).hide().change()):($("input[name="+b.id+"_input1]",f).show().change(),$("label[for="+b.id+"_input1]",f).show(),$("input[name="+b.id+"_input0]",f).show().change());else if(i&&i.attr("type")in{text:1,textarea:1})if(b.value.search(/exact/)<0||i.attr("type")!=="textarea"){if(b.value.search(/^-?in$/)>=0&&i.attr("type")==="text")if(i.data("switch"))i.data("switch").data("switch",i),i.before(i.data("switch")).detach(),i.data("switch").keyup();else{var e=$('<textarea rows="8" id="'+i.attr("id")+'" name="'+i.attr("name")+'" cols="25"></textarea>').data("switch",i);i.before(e).detach(),d=f.data("datasource")||{},d[i.attr("name")]instanceof Array?g.updateElement(null,{name:i.attr("name"),value:d[i.attr("name")]}):typeof d[i.attr("name")]==="string"?g.updateElement(null,{name:i.attr("name"),value:[d[i.attr("name")]]}):g.updateElement(null,{name:i.attr("name"),value:[]}),e.keyup()}}else i.data("switch").data("switch",i),i.before(i.data("switch")).detach(),i.data("switch").keyup()}});if(a.target.type==="select-multiple"){var k=[],l=h.length;for(var m=0;m<l;m++){var n=h[m];k.push(n in e.s_to_primative_map?e.s_to_primative_map[n]:n)}c=k}else c=h[0]in e.s_to_primative_map?e.s_to_primative_map[h[0]]:h[0];b.is("[data-optional=true]")&&(c=$.type(c)in{string:1,array:1}&&c.length===0?undefined:c),c=this.state==="INIT"&&b.css("display")!=="none"||b.is(":visible")&&b.is(":enabled")?c:undefined,f.trigger("ElementChangedEvent",[{name:a.target.name,value:c}]);break;case"textarea":c=this.state==="INIT"&&b.css("display")!=="none"||b.is(":visible")&&b.is(":enabled")?b.val().split("\n"):undefined,f.trigger("ElementChangedEvent",[{name:a.target.name,value:c}]);break;default:var o=$(a.target).closest("p").find("select").val(),p=a.target.name.substr(0,a.target.name.length-1);switch(b.attr("data-validate")){case"number":case"decimal":case"date":var q=b.attr("data-validate"),r=$("input[name="+p+"0]",f),s=$("input[name="+p+"1]",f),t;if(q==="date")var u=new Date(r.val()),v=new Date(s.val());else var u=parseFloat(r.val()),v=parseFloat(s.val());q!=="date"&&b.is(":visible")&&isNaN(Number(b.val()))?(t=$.Event("InvalidInputEvent"),b.trigger(t)):$(a.target).hasClass("invalid")?(t=$.Event("InputCorrectedEvent"),b.trigger(t)):o.search(/range/)>=0&&u>v?(t=$.Event("InvalidInputEvent"),t.reason="badrange",t.message="First input must be less than second input.",b.parent().trigger(t)):$(a.target).parent().hasClass("invalid_badrange")&&(s.css("display")==="none"||u<v)&&(t=$.Event("InputCorrectedEvent"),t.reason="badrange",b.parent().trigger(t));break;default:}c=this.state==="INIT"&&b.css("display")!=="none"||b.is(":visible")&&b.is(":enabled")?b.val():undefined,f.trigger("ElementChangedEvent",[{name:a.target.name,value:c}])}a.stopPropagation()}},updateElement:function(a,b){var c=$("[name="+b.name+"]",this.dom);if(c.length!==0){var d=c.attr("type");switch(d){case"checkbox":c.attr("checked",b.value);break;case"select-multiple":var e=$.isArray(b.value)?b.value:[b.value];$("option",c).each(function(a,b){var c=$.map(e,function(a,b){return typeof a in{string:1,number:1}?a:String(a)});$.inArray(b.value,c)!=-1?b.selected=!0:b.selected=!1});break;case"textarea":c.val(b.value.join("\n"));break;default:if($.isArray(b.value))break;c.attr("value",typeof b.value in{string:1,number:1}?b.value:String(b.value))}}}},{s_to_primative_map:{"true":!0,"false":!1,"null":null},opRe:/^(\d*)_(\d+(?:OR\d+)*)_operator$/,nullboolean_tmpl:$.jqotec(['<label for="<%=this.field_id%>"><%=this.label%></label>','<select data-datatype="nullboolean"data-optional="<%=this.optional%>"  multiple id ="<%=this.field_id%>" name="<%=this.field_id%>">','<option <%=this["default"]===true?"selected":""%> value="true">Yes</option>','<option <%=this["default"]===false?"selected":""%> value="false">No</option>','<option <%=this["default"]===null?"selected":""%> value="null">No Data</option>',"</select>"].join("")),boolean_tmpl:$.jqotec(["<%if (this.optional) {%>",'<label for="<%=this.field_id%>"><%=this.label%></label>','<select data-datatype="boolean" data-optional="<%=this.optional%>" id ="<%=this.field_id%>" name="<%=this.field_id%>">','<option value="">No Preference</option>','<option <%=this["default"]===true?"selected":""%> value="true">Yes</option>','<option <%=this["default"]===false?"selected":""%> value="false">No</option>',"</select>","<%} else {%>",'<input type="checkbox" name="<%=this.field_id%>" value="<%=this.field_id%>" <%= this["default"] ? "checked":""%>/>','<label for="<%=this.field_id%>"><%=this.label%></label>',"<%}%>"].join("")),number_tmpl:$.jqotec(['<label for="<%=this.field_id%>"><%=this.label%></label>','<select id="<%=this.field_id%>_operator" name="<%=this.field_id%>_operator">',b.join(""),"</select>",'<span class="input_association" name="<%=this.field_id%>_input_assoc">','<input data-validate="<%=this.datatype%>" id="<%=this.field_id%>_input0" type="text" name="<%=this.field_id%>_input0" size="5">','<label for="<%=this.field_id%>_input1">and</label>','<input data-validate="<%=this.datatype%>" id="<%=this.field_id%>_input1" type="text" name="<%=this.field_id%>_input1" size="5">',"</span>"].join("")),string_tmpl:$.jqotec(["<% if (this.choices) {%>",'<label for="<%=this.field_id%>"><%=this.label%></label>','<select id="<%=this.field_id%>-operator" name="<%=this.field_id%>_operator">',c.join(""),"</select>",'<select multiple="multiple" id="<%=this.field_id%>-value" name="<%=this.field_id%>" size="3" data-optional="<%=this.optional%>" >',"<% for (var index = 0; index < this.choices.length; index++) { %>",'<option value="<%=this.choices[index][0]%>"><%=this.choices[index][1]%></option>',"<%}%>","</select>","<%} else {%>",'<label for="<%=this.field_id%>"><%=this.label%></label>','<select id="<%=this.field_id%>-operator" name="<%=this.field_id%>_operator">',d.join(""),"</select>",'<input data-optional="<%=this.optional%>" type="text" id="<%=this.field_id%>_text" name="<%=this.field_id%>" size = "10">',"<%}%>"].join("")),stringlist_tmpl:$.jqotec(['<label for="<%=this.field_id%>"><%=this.label%></label>','<select id="<%=this.field_id%>-operator" name="<%=this.field_id%>_operator">',c.join(""),"</select>",'<textarea data-optional="<%=this.optional%>" id="<%=this.field_id%>_text" name="<%=this.field_id%>" rows="8" cols="25"></textarea>'].join("")),pk_tmpl:$.jqotec(['<p><label for="<%=this.pkchoice_id%>"><%=this.pkchoice_label%></label>','<select id="<%=this.pkchoice_id%>" name="<%=this.pkchoice_id%>">',"<% for (index in this.pkchoices) { %>",'<option value="<%=this.pkchoices[index][0]%>" <%=this.pkchoices[index][0]==this.pkchoice_default ? "selected":""%>><%=this.pkchoices[index][1]%></option>',"<%}%>","</select></p>"].join(""))});return e})