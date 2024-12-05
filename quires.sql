-- Write CREATE TABLE statements for tables organization, channel, user, and message.
    -- organization. This table should at least have column(s): name
    CREATE TABLE organization (
        organization_id INT AUTO_INCREMENT PRIMARY KEY,   
        organization_name VARCHAR(255) NOT NULL          
    ) ;  
    select * from organization; 

    -- channel. This table should at least have column(s):name
    create table channel(
        channel_id int AUTO_INCREMENT PRIMARY KEY,
        channel_name VARCHAR(200) NOT NULL,
        organization_id int NOT NULL,
        FOREIGN KEY  (organization_id) REFERENCES organization(organization_id)
        ON DELETE CASCADE ON UPDATE CASCADE
    ) 
    select * from channel; 

    -- user. This table should at least have column(s):
    CREATE TABLE user(
        user_id int AUTO_INCREMENT PRIMARY KEY,
        user_name varchar(200) NOT NULL
    
    ) 
    SELECT * FROM user; 

    -- message. This table should have at least columns(s):
    CREATE TABLE message(
        message_id INT AUTO_INCREMENT PRIMARY key,
        post_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
        content text not null,
        user_id int not null, 
        channel_id int not NULL,
        FOREIGN key (user_id) REFERENCES user(user_id)
        on DELETE CASCADE on UPDATE CASCADE,
        FOREIGN KEY (channel_id) REFERENCES channel(channel_id)
        ON DELETE CASCADE on UPDATE CASCADE
    )  
-- 3.Add additional join tables needed, if any.
CREATE TABLE channel_user (
    id INT AUTO_INCREMENT PRIMARY KEY,
    channel_id INT NOT NULL,
    user_id INT NOT NULL,
    FOREIGN KEY (channel_id) REFERENCES channel(channel_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (user_id) REFERENCES user(user_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);
SELECT * from message; 

-- Write INSERT queries to add information to the database.
1.-- One organization, Lambda School
INSERT INTO organization
(organization_name)
 VALUES ('Lambda School')
--  2.Three users, Alice, Bob, and Chris
INSERT INTO user 
(user_name)
VALUES('Alice'),('Bob'),('Chris')
-- 3.Two channels, #general and #random
INSERT INTO channel 
(channel_name,organization_id)
VALUES('#general',1),('#random',1)
-- 4.10 messages (at least one per user, and at least one per channel).
INSERT INTO messagea
(content,user_id,channel_id)
VALUES('hello world',1,1),
('localhost',2,1),
('information',3,1),
('machine learning',2,2),
('gen ai',1,2),
('rag',2,1),
('chatbot',3,1),
('superdesk',2,1),
('vaelariya',1,1),
('superinsert',2,1)
-- 5.Alice should be in #general and #random.
INSERT into channel_user
(user_id,channel_id)
VALUES(1,1),
(1,2)
-- 6.Bob should be in #general.
INSERT into channel_user
(user_id,channel_id)
VALUES
(2,1),
(3,2)
-- 7.Chris should be in #random.
INSERT into channel_user
(user_id,channel_id)
VALUES(3,2)
-- Write SELECT queries to:
-- 1.List all organization names.
 select organization_name from organization
--  2.List all channel names.
SELECT channel_name from channel 
-- 3.List all channels in a specific organization by organization name.
SELECT o.organization_name ,c.channel_name from organization AS o
 left JOIN channel as c 
on o.organization_id=c.organization_id
-- 4.List all messages in a specific channel by channel name #general in order of post_time, descending
select m.content , c.channel_name from message as m
left JOIN channel as c
ON m.channel_id=c.channel_id
where c.channel_name='#general'
ORDER BY m.post_time desc 
-- 5.List all channels to which user Alice belongs.
select c.channel_name from channel_user as cu 
left join user as u 
on cu.user_id=u.user_id 
LEFT JOIN channel as c 
on c.channel_id=cu.channel_id
where u.user_name='Alice' 
-- 6.List all users that belong to channel #general.
select u.user_name from channel_user AS cu 
LEFT JOIN channel as c 
ON cu.channel_id=c.channel_id
LEFT JOIN user as u 
ON u.user_id=cu.user_id
where c.channel_name='#general' 
-- 7.List all messages in all channels by user Alice.
SELECT m.content from message as m 
LEFT JOIN user as u 
on m.user_id=u.user_id 
where u.user_name='Alice' 

-- 8.List all messages in #random by user Bob.
SELECT m.content from message as m 
LEFT JOIN user as u 
on m.user_id=u.user_id 
LEFT JOIN channel as c 
on c.channel_id=m.channel_id
where u.user_name='Bob'  and c.channel_name='#random' 
-- 9.List the count of messages across all channels per user. (Hint: COUNT, GROUP BY.)

-- The title of the users name column should be User Name and the title of the count column should be Message Count. (The SQLite commands .mode column and .header on might be useful here.)

-- The user names should be listed in reverse alphabetical order.
select u.user_name as User_name , count(m.content) as message_count from message as m
LEFT JOIN user as u
on m.user_id=u.user_id
group by u.user_name
order by u.user_name desc
-- 10.Stretch!] List the count of messages per user per channel.
select u.user_name as user  ,c.channel_name as channel, count(m.content) as message from message as m
LEFT JOIN user as u
on m.user_id=u.user_id
LEFT JOIN channel as c 
on c.channel_id=m.channel_id
group by c.channel_name ,u.user_name

-- 6.What SQL keywords or concept would you use if you wanted to automatically delete all messages by a user if that user were deleted from the user table?
-- ON DELETE CASCADE
