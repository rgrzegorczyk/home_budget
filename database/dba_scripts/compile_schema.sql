begin 
  	  	dbms_utility.compile_schema(
  schema        => user ,
  compile_all   =>TRUE,
  reuse_settings =>TRUE);
end;
/