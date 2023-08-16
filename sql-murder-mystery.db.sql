/* Start by retrieving the crime scene report from the police 
department’s database and filter the reports by crime date (Jan.15, 2018) and city (SQL City). */
select * 
from crime_scene_report 
where city = 'SQL City' AND date = 20180115 and type = 'murder';
/* The crime scene report indicates there were two witnesses or persons who witnessed the
murder happen; one Annabel who lives in Franklin Ave and a witness who lives in Northwestern Dr.
So we search for the second witness with the given information (last house on Northwestern Dr) */
select * 
from person 
where address_street_name = 'Northwestern Dr' 
order by address_number DESC;
/* Now that we have the names of both witnesses; Morty Shapiro with id 14887 and 
Annabel Miller with id 16371, we filter their interview statement from the interview
table by their id */
select * 
from interview 
WHERE person_id in (16371, 14887);
/* Morty claimed to have heard a gunshot, describing the man who ran out was with 
a "Get Fit Now Gym" bag that had a membership number starting with "48Z" and escaped in 
a car with plate number that included "H42W", stating
only gold members use those bags while Annabel claimed to have witnessed the murder 
happen and recognized the killer from her gym while she was working out the 
previous week on the 9th of January. 
With these credible statements, we just need to filter the gym membership table by 
the following parameters; gym membership id and status. */
select * 
from get_fit_now_member 
where id LIKE '48Z%' and membership_status = 'gold';
/* The two members with a gold membership status and possibly the said membership id 
are Joe Germuska and Jeremy Bowers. Now we lookup their details from the persons table
by their id. */
select * 
from person 
WHERE id IN (28819, 67318);
/* Then let's find out if one of these two members checked in to the gym on January 9th
based on Annabel's statement using their membership id and check in date. */ 
select * 
from get_fit_now_check_in 
WHERE membership_id in ('48Z7A', '48Z55') and check_in_date = 20180109;
/* Since they both checked in on the same date, it's quite difficult to narrow down 
which of these two members committed the murder. So utilize one last lead which we haven't
considered; the plate number as per Morty's statement. Now we just need to join the 
person table with the drivers license table to narrow down who our culprit really is. */
select person.name, person.id, drivers_license.plate_number
from drivers_license 
join person 
on drivers_license.id = person.license_id
WHERE plate_number like '%H42W%' and person.id in (28819, 67318);
/* Jeremy Bowwers is our culprit. */
select * 
from interview 
WHERE person_id IN (67318);
/* According to his statement, he was hired by a rich woman with a red hair
around 5'5" (65") or 5'7" (67"). She drives a Tesla Model S and attended 
the SQL Symphony Concert 3 times in December 2017. 
We found our culprit, now we should try to see if we can find the mystery rich lady who
hired him to do the job in the person table by the parameters in his statement. */
select person.name, person.id, gender, age, hair_color, height
from drivers_license 
join person on drivers_license.id = person.license_id
where car_make = 'Tesla' and car_model = 'Model S' and gender = 'female' and hair_color = 'red';
/* Now we have three women matching that description but so we still have to narrow down 
who ordered the murder by the one parameter left to explore; she attended SQL Symphony Concert 
thrice in December 2017 */
select * 
from facebook_event_checkin 
where person_id in (78881,90700,99716);
/* Finally, we have an id on our shotcaller who attended the concert thrice. Now we just need 
to join the facebook_event_checkin table with the drivers_license table to get a name. */
select name, person_id, event_name 
from facebook_event_checkin 
join person on facebook_event_checkin.person_id = person.id
where person_id = 99716;
/* There you have it! Our Shotcaller!! */
