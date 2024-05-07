accept tech_name char prompt 'Enter the name of the employee'
accept start_date char prompt 'Enter the starting date as YYYY-MM-DD'
accept end_date char prompt 'Enter the ending date as YYYY-MM-DD'
declare
  v_tech_name technician.technician_name%type:='&tech_name';
  v_start_date date:= to_date('&start_date', 'YYYY-MM-DD');
  v_end_date date:=to_date('&end_date', 'YYYY-MM-DD');
  v_number_of_samples number:=0;
  c_samples sys_refcursor;  
  l_sample_id sample.sample_id%type;  
  l_test_name test.test_name%type;
  l_start_date date;
  l_end_date date;
begin
  GESTION_LABORATOIRE.CHERCHERTESTSFAITPARTECH(v_tech_name, 
                           v_start_date, 
                           v_end_date, 
                           v_number_of_samples,
                           c_samples
                           );
  dbms_output.put_line('Total number of samples for '
                        ||initcap(v_tech_name)
                        ||': '
                        ||v_number_of_samples);
  loop
    fetch c_samples into
      l_sample_id,
      l_test_name,
      l_start_date,
      l_end_date;
      exit when c_samples%notfound;
      dbms_output.put_line('Sample number: '||l_sample_id
                            ||' Test: '||l_test_name
                            ||' Start date: '||to_char(l_start_date, 'YYYY-MM-DD')
                            ||' End date: '||to_char(l_end_date, 'YYYY-MM-DD'));      
  end loop;  
  close c_samples;
  exception
  when GLOBAL_EXCEPTIONS.TECH_NOT_FOUND THEN
    dbms_output.put_line('technician not found');
    --log into something
  --when others
    --dbms other errors
    --log into table
end;