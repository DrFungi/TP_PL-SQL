select *
from tests_per_tech
where technician_name='David'
order by receivedon;

select count(technician_name)
    --into p_number_of_samples
    from tests_per_tech
    where technician_name = 'David';