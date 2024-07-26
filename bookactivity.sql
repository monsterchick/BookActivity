/*
 Navicat Premium Data Transfer

 Source Server         : yaphp.net
 Source Server Type    : MySQL
 Source Server Version : 50744
 Source Host           : mysql.yaphp.net:3306
 Source Schema         : bookactivity

 Target Server Type    : MySQL
 Target Server Version : 50744
 File Encoding         : 65001

 Date: 10/05/2024 17:39:52
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for activity
-- ----------------------------
DROP TABLE IF EXISTS `activity`;
CREATE TABLE `activity`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `start_date` datetime(0) NULL DEFAULT NULL,
  `end_date` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of activity
-- ----------------------------
INSERT INTO `activity` VALUES (1, 'Winter Warm-Up Readathon', 'Cozy up with books during winter. \r\nLog 100 hours of reading.', 'TimeBased', '2023-12-01 00:00:00', '2024-01-31 23:59:59');
INSERT INTO `activity` VALUES (2, 'Mid-Year Momentum', 'Maintain your reading pace. Aim for 75 hours over 3 months.', 'TimeBased', '2024-04-01 00:00:00', '2024-06-30 23:59:59');
INSERT INTO `activity` VALUES (3, 'Autumn Reading Retreat', 'Escape into stories. Complete 50 hours of reading in fall.', 'TimeBased', '2024-09-01 00:00:00', '2024-11-30 23:59:59');
INSERT INTO `activity` VALUES (4, 'Spring Sprint', 'Short and intense! 30-hour reading challenge in April.', 'TimeBased', '2025-04-01 00:00:00', '2025-04-30 23:59:59');
INSERT INTO `activity` VALUES (5, 'Year-End Bibliophile Blast', 'End the year strong. Read 20 books before New Year.', 'QuantityBased', '2023-10-01 00:00:00', '2023-12-31 23:59:59');
INSERT INTO `activity` VALUES (6, 'Summer Reading Escapade', 'Voyage through literature. Complete 15 books this summer.', 'QuantityBased', '2024-04-01 00:00:00', '2024-08-31 23:59:59');
INSERT INTO `activity` VALUES (7, 'New Year, New Reads', 'Start fresh. Read and review 12 new releases in Q1.', 'QuantityBased', '2024-03-01 00:00:00', '2024-06-30 23:59:59');
INSERT INTO `activity` VALUES (8, 'Genre Grand Tour', 'Diversify your reads. Explore 10 different genres in 6 months.', 'QuantityBased', '2024-03-02 00:00:00', '2024-06-30 23:59:59');
INSERT INTO `activity` VALUES (10, 't', 'ttt', 'QuantityBased', '2024-05-07 00:00:00', '2024-05-31 00:00:00');
INSERT INTO `activity` VALUES (11, 't', 'ttt', 'QuantityBased', '2024-05-07 00:00:00', '2024-05-31 00:00:00');

-- ----------------------------
-- Table structure for book
-- ----------------------------
DROP TABLE IF EXISTS `book`;
CREATE TABLE `book`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `cover` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `author` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `category` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `summary` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `file` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 25 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of book
-- ----------------------------
INSERT INTO `book` VALUES (2, 'Ikigai: The Japanese Secret to a Long and Happy Life', 'https://m.media-amazon.com/images/I/71xH0ALI4-L._AC_UL320_.jpg', 'Héctor García and Francesc Miralles', 'Practical', '“Ikigai urges individuals to simplify their lives by pursuing what sparks joy for them. . . . Much in the same way that The Life-Changing Magic of Tidying Up emphasizes ‘choosing what we want to keep, and not what we want to get rid of,’ [Ikigai] demonstrates that aging could be an opportunity to keep working, keep smiling, keep active, and keep being social.” —KonMari Newsletter\r\n\r\n“Want to live longer? Keep super busy. If hygge is the art of doing nothing, ikigai is the art of doing something—and doing it with supreme focus and joy. . . . Pack up those cozy blankets and candles you purchased in last year’s hygge-fueled Ikea spree. Fall’s biggest imported lifestyle trend is ikigai, and it might help you live to 100.” —New York Post\r\n\r\n“Originating from a country with one of the world’s oldest populations, ikigai is becoming popular outside of Japan as a way to live longer and better. . . . [It] is helping people live longer on Okinawa as it gives them purpose.” —World Economic Forum', '/uploads/book/pg73580.txt');
INSERT INTO `book` VALUES (3, 'The Book You Wish Your Parents Had Read', 'https://m.media-amazon.com/images/I/714tZOK0ITL._AC_UL320_.jpg', 'Philippa Perry', 'Clinical Psychology', 'Made me think about me and who I am and my parents and who they are and maybe, hopefully, one day what sort of parent I might strive to be ― Dolly Alderton\r\n\r\nI don\'t have kids but [this book] is a fascinating read on the emotional baggage we all carry ― Elizabeth Day, How to Fail podcast\r\n\r\nThe Easter holidays were a complete joy because of your book - I feel about a trillion times more relaxed and connected as a parent and I have also found it very helpful for my sobriety and recovery ― Bryony Gordon', '/uploads/book/pg73580.txt');
INSERT INTO `book` VALUES (4, 'The Mountain Is You: Transforming Self-Sabotage Into Self-Mastery', 'https://m.media-amazon.com/images/I/71AHFDEpkdL._AC_UL320_.jpg', 'Brianna Wiest', 'Encouragement', 'This is a book about self-sabotage. Why we do it, when we do it, and how to stop doing it—for good.Coexisting but conflicting needs create self-sabotaging behaviors. This is why we resist efforts to change, often until they feel completely futile. But by extracting crucial insight from our most damaging habits, building emotional intelligence by better understanding our brains and bodies, releasing past experiences at a cellular level, and learning to act as our highest potential future selves, we can step out of our own way and into our potential.For centuries, the mountain has been used as a metaphor for the big challenges we face, especially ones that seem impossible to overcome. To scale our mountains, we actually have to do the deep internal work of excavating trauma, building resilience, and adjusting how we show up for the climb.In the end, it is not the mountain we master, but ourselves.', '/uploads/book/pg73580.txt');
INSERT INTO `book` VALUES (5, 'The Culture Map: Decoding How People Think, Lead, and Get Things Done Across Cultures', 'https://m.media-amazon.com/images/I/71ReFbLwF1L._AC_UL320_.jpg', 'Erin Meyer', 'Culture', 'Erin Meyer is a professor at INSEAD, one of the world\'s leading international business schools. Her work focuses on how the world\'s most successful global leaders navigate the complexities of cultural differences in a multicultural environment. Living and working in Africa, Europe, and the United States prompted Meyer\'s study of the communication patterns and business systems of different parts of the world. Her framework allows international executives to pinpoint their leadership preferences, and compare their methods to the management styles of other cultures.\r\n\r\nHer work has appeared in Harvard Business Review, Singapore Business Times, and Forbes.com. In 2013 Erin was selected by the Thinkers50 Radar list as one of the world\'s up-and-coming business thinkers. She is the recipient of the 2015 Thinkers50 RADAR Award. With Reed Hastings, she is the co-author of No Rules Rules: Netflix and the Culture of Reinvention. Follow her on Twitter: @ErinMeyerINSEAD', '/uploads/book/pg73580.txt');
INSERT INTO `book` VALUES (6, 'The Boy, the Mole, the Fox and the Horse: A Great Gift for Book Lovers', 'https://m.media-amazon.com/images/I/71eJk7GtUOL._AC_UL320_.jpg', 'Charlie Mackesy', 'Specific Philosophical Topics', '“The Boy, the Mole, the Fox and the Horse is not only a thought-provoking, discussion-worthy story, the book itself is an object of art.”\r\n-- New York Times\r\n\r\n“The world that I long to inhabit is the one that Charlie Mackesy has created – a world of infinite kindness, wisdom, mutual care and tenderness, and true love between real friends. My prayer/hope is that our world will become more like this one.” -- Elizabeth Gilbert, New York Times bestselling author of Eat, Pray, Love and Big Magic\r\n\r\n\"I felt this book down to my core.\" -- Hoda Kotb\r\n\r\n\"Love, friendship, and kindness--this book speaks a universal language.\" -- Bear Grylls\r\n\r\n\"A wonderful work of art and a wonderful window into the human heart\" -- Richard Curtis', '/uploads/book/pg73580.txt');
INSERT INTO `book` VALUES (7, 'The Creative Act: A Way of Being', 'https://m.media-amazon.com/images/I/918EkrTDaRL._AC_UL320_.jpg', 'Rick Rubin', 'Self Help Memory Improvement', '\"A work of transcendent literature, one that suggests the universe still smiles upon us despite all indications to the contrary.\" --The Wall Street Journal\r\n\"It really feels to me like the rare book that\'s evergreen...It\'s a book I wish I would have had on my shelf when I was 25. It\'s a book I would give to people who are 25. Maybe it will be the ultimate graduation gift.\" -- Steve Levitt, People I (Mostly) Admire\r\n\r\n\"To Rubin, art is the ultimate form of self-actualization, a noble calling that enriches the soul . . . So, how does an artist move from conception to creation? Rubin methodically lays out the process, offering a mixture of encouragement, inspiration and tips . . . Rubin has written a fascinating book infused with deep thoughts, insight and, yes, lots and lots of creativity.\" --Los Angeles Times', '/uploads/book/pg73580.txt');
INSERT INTO `book` VALUES (8, 'The Psychology of Money: Timeless lessons on wealth, greed, and happiness', 'https://m.media-amazon.com/images/I/71aG0m9XRcL._AC_UL320_.jpg', 'Morgan Housel', 'Teen and Young Adult', '\"Morgan Housel is one of the brightest new lights among financial writers. He is accessible to everyone wanting to learn more about the psychology of money. I highly recommend this book.\" -- James P. O\'Shaughnessy, Author, What Works on Wall Street \"Housel\'s observations often hit the daily double: they say things that haven\'t been said before, and they make sense.\" -- Howard Marks, Director and Co-Chairman, Oaktree Capital & Author, The Most Important Thing and Mastering the Market Cycle \"Few people write about finance with the graceful clarity of Morgan Housel. The Psychology of Money is an essential read for anyone who wants to make wiser decisions or live a richer life.\" -- Daniel H. Pink, #1 New York Times Bestselling Author of When, To Sell Is Human, and Drive \"The Psychology of Money is bursting with interesting ideas and practical takeaways. Quite simply, it is essential reading for anyone interested in being better with money. Everyone should own a copy.\" -- James Clear, Author, million-copy bestseller, Atomic Habits \"Morgan Housel is that rare writer who can translate complex concepts into gripping, easy-to-digest narrative. The Psychology of Money is a fast-paced, engaging read that will leave you with both the knowledge to understand why we make bad financial decisions and the tools to make better ones.\" -- Annie Duke, Author, Thinking in Bets', '/uploads/book/pg73580.txt');
INSERT INTO `book` VALUES (1, 'Atomic Habits', 'https://m.media-amazon.com/images/I/81Ls+SBCLiL._SL1500_.jpg', 'James Clear', 'Emotional', 'A supremely practical and useful book. James Clear distils the most fundamental information about habit formation, so you can accomplish more by focusing on less. -- Mark Manson, author of The Subtle Art of Not Giving a F*ck\r\n\r\nIt\'s an absolutely fabulous book and it doesn\'t surprise me that it\'s sold so many copies . . . Very useful, very practical, super well-researched. -- Dr Rangan Chatterjee\r\n\r\nAtomic Habits is a step-by-step manual for changing routines . . . Inspiring real-life stories. ― Financial Times\r\n\r\nJames Clear has spent years honing the art and studying the science of habits. This engaging, hands-on book is the guide you need to break bad routines and make good ones.\r\n\r\nA special book that will change how you approach your day and live your life.\r\n', '/uploads/book/pg73580.txt');
INSERT INTO `book` VALUES (24, 'test', '/uploads/avatar/4ef3f20b20236287ea84068646577436.jpg', '1', '1', '2', '/uploads/book/d7c2a48383edff541f018c980b41d507.txt');

-- ----------------------------
-- Table structure for comment
-- ----------------------------
DROP TABLE IF EXISTS `comment`;
CREATE TABLE `comment`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `book_id` int(11) NULL DEFAULT NULL,
  `user_id` int(11) NULL DEFAULT NULL,
  `comment` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `created_at` datetime(0) NULL DEFAULT NULL,
  `updated_at` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 28 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of comment
-- ----------------------------
INSERT INTO `comment` VALUES (3, 1, 1, '3', '2024-04-20 18:18:13', '2024-05-09 18:15:07');
INSERT INTO `comment` VALUES (4, 1, 1, '1234', '2024-04-20 18:18:42', '2024-05-09 18:15:07');
INSERT INTO `comment` VALUES (5, 1, 1, 'ttt', '2024-04-20 18:21:10', '2024-05-09 18:15:07');
INSERT INTO `comment` VALUES (6, 1, 1, '123123', '2024-04-20 18:50:33', '2024-05-09 18:15:07');
INSERT INTO `comment` VALUES (7, 1, 1, '123123', '2024-04-20 19:05:07', '2024-05-09 18:15:07');
INSERT INTO `comment` VALUES (9, 1, 1, '111', '2024-04-20 19:05:35', '2024-05-09 18:15:07');
INSERT INTO `comment` VALUES (10, 1, 1, '333', '2024-04-20 19:05:51', '2024-05-09 18:15:07');
INSERT INTO `comment` VALUES (11, 1, 1, '111', '2024-04-20 19:24:22', '2024-05-09 18:15:07');
INSERT INTO `comment` VALUES (14, 1, 1, 'tttt', '2024-04-20 21:06:45', '2024-05-09 18:15:08');
INSERT INTO `comment` VALUES (15, 1, 1, 'test', '2024-04-20 21:29:13', '2024-05-09 18:15:08');
INSERT INTO `comment` VALUES (16, 1, 1, '1231', '2024-04-20 22:53:09', '2024-05-09 18:15:08');
INSERT INTO `comment` VALUES (17, 1, 2, 'hi', '2024-04-20 22:55:11', '2024-05-09 18:15:08');
INSERT INTO `comment` VALUES (18, 1, 2, 'test', '2024-04-21 00:08:30', '2024-05-09 18:15:08');
INSERT INTO `comment` VALUES (25, 1, 2, 'hi', '2024-05-09 18:43:47', '2024-05-09 18:43:47');
INSERT INTO `comment` VALUES (26, 6, 2, '111', '2024-05-09 19:27:52', '2024-05-09 19:27:52');
INSERT INTO `comment` VALUES (27, 1, 2, 'teert', '2024-05-10 09:28:43', '2024-05-10 09:28:43');

-- ----------------------------
-- Table structure for logs
-- ----------------------------
DROP TABLE IF EXISTS `logs`;
CREATE TABLE `logs`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NULL DEFAULT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `create_at` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 27 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of logs
-- ----------------------------
INSERT INTO `logs` VALUES (1, 2, 'login success, ip:127.0.0.1', 'Login', '2024-05-10 16:02:49');
INSERT INTO `logs` VALUES (2, 1, 'login success, ip:127.0.0.1', 'Login', '2024-05-10 16:25:55');
INSERT INTO `logs` VALUES (3, 1, 'login success, ip:127.0.0.1', 'Login', '2024-05-10 16:26:29');
INSERT INTO `logs` VALUES (4, 1, 'login success, ip:127.0.0.1', 'Login', '2024-05-10 16:26:52');
INSERT INTO `logs` VALUES (5, 2, 'login success, ip:127.0.0.1', 'Login', '2024-05-10 16:31:45');
INSERT INTO `logs` VALUES (6, 2, 'login success, ip:127.0.0.1', 'Login', '2024-05-10 16:32:28');
INSERT INTO `logs` VALUES (7, 1, 'login success, ip:127.0.0.1', 'Login', '2024-05-10 16:33:31');
INSERT INTO `logs` VALUES (8, 1, 'login success, ip:127.0.0.1', 'Login', '2024-05-10 17:21:24');
INSERT INTO `logs` VALUES (9, 2, 'login success, ip:127.0.0.1', 'Login', '2024-05-10 17:22:09');
INSERT INTO `logs` VALUES (10, 2, 'login success, ip:127.0.0.1', 'Login', '2024-05-10 17:22:57');
INSERT INTO `logs` VALUES (11, 1, 'login success, ip:127.0.0.1', 'Login', '2024-05-10 17:24:18');
INSERT INTO `logs` VALUES (12, 1, 'login success, ip:127.0.0.1', 'Login', '2024-05-10 17:24:53');
INSERT INTO `logs` VALUES (13, 2, 'login success, ip:127.0.0.1', 'Login', '2024-05-10 17:25:29');
INSERT INTO `logs` VALUES (14, 2, 'login success, ip:127.0.0.1', 'Login', '2024-05-10 17:26:00');
INSERT INTO `logs` VALUES (15, 2, 'login success, ip:127.0.0.1', 'Login', '2024-05-10 17:27:46');
INSERT INTO `logs` VALUES (16, 1, 'login success, ip:127.0.0.1', 'Login', '2024-05-10 17:27:54');
INSERT INTO `logs` VALUES (17, 2, 'login success, ip:127.0.0.1', 'Login', '2024-05-10 17:28:12');
INSERT INTO `logs` VALUES (18, 1, 'login success, ip:127.0.0.1', 'Login', '2024-05-10 17:36:10');
INSERT INTO `logs` VALUES (19, 1, 't,The event has begun', 'Activity', '2024-05-10 09:36:56');
INSERT INTO `logs` VALUES (20, 2, 't,The event has begun', 'Activity', '2024-05-10 09:36:56');
INSERT INTO `logs` VALUES (21, 3, 't,The event has begun', 'Activity', '2024-05-10 09:36:56');
INSERT INTO `logs` VALUES (22, 4, 't,The event has begun', 'Activity', '2024-05-10 09:36:56');
INSERT INTO `logs` VALUES (23, 1, 'test,AVAILABLE', 'Activity', '2024-05-10 09:38:51');
INSERT INTO `logs` VALUES (24, 2, 'test,AVAILABLE', 'Activity', '2024-05-10 09:38:51');
INSERT INTO `logs` VALUES (25, 3, 'test,AVAILABLE', 'Activity', '2024-05-10 09:38:51');
INSERT INTO `logs` VALUES (26, 4, 'test,AVAILABLE', 'Activity', '2024-05-10 09:38:51');

-- ----------------------------
-- Table structure for progress
-- ----------------------------
DROP TABLE IF EXISTS `progress`;
CREATE TABLE `progress`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NULL DEFAULT NULL,
  `book_id` int(11) NULL DEFAULT NULL,
  `progress` float(5, 2) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of progress
-- ----------------------------
INSERT INTO `progress` VALUES (1, 2, 1, 7.67);
INSERT INTO `progress` VALUES (2, 2, 2, 23.02);
INSERT INTO `progress` VALUES (3, 2, 6, 7.67);
INSERT INTO `progress` VALUES (4, 2, 8, 0.00);
INSERT INTO `progress` VALUES (5, 2, 3, 19.95);
INSERT INTO `progress` VALUES (6, 2, 4, 100.00);
INSERT INTO `progress` VALUES (7, 2, 5, 1.53);
INSERT INTO `progress` VALUES (8, 1, 2, 0.00);

-- ----------------------------
-- Table structure for record
-- ----------------------------
DROP TABLE IF EXISTS `record`;
CREATE TABLE `record`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `activity_id` int(11) NULL DEFAULT NULL,
  `user_id` int(11) NULL DEFAULT NULL,
  `type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `value` int(11) NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of record
-- ----------------------------
INSERT INTO `record` VALUES (1, 2, 1, 'TimeBased', 23293);
INSERT INTO `record` VALUES (2, 2, 2, 'TimeBased', 91328);
INSERT INTO `record` VALUES (3, 2, 3, 'TimeBased', 5000);
INSERT INTO `record` VALUES (4, 2, 4, 'TimeBased', 8000);
INSERT INTO `record` VALUES (5, 6, 2, 'QuantityBased', 3);

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `password` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `role` int(1) NULL DEFAULT 1,
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `phone` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '/uploads/avatar/avatar.png',
  `create_at` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (1, 'admin', '123123', 0, 'admin@gmail.com', '1123123', '/uploads/avatar/avatar.png', '2024-03-29 12:12:40');
INSERT INTO `user` VALUES (2, 'test', '123123', 1, '878920787@qq.com', '13089179136', '/uploads/avatar/1301d9b8ee707b8a17565cb4088e45dc.jpg', '2024-03-30 12:12:38');
INSERT INTO `user` VALUES (3, 'Joe1', '123123', 1, 'joe@gmail.com', '2224', '/uploads/avatar/e61807d901864cccd51344d6c74c6a40.jpg', '2024-04-01 05:05:18');
INSERT INTO `user` VALUES (4, 'Anne', '123123', 1, 'anne@gmail.com', '132123', '/uploads/avatar/1301d9b8ee707b8a17565cb4088e45dc.jpg', '2024-04-01 06:50:38');

SET FOREIGN_KEY_CHECKS = 1;
