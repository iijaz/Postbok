//
//  DBConstants.swift
//  CodeVise
//
//  Created by JuicePhactree on 10/31/17.
//  Copyright © 2017 Arslan Javed. All rights reserved.
//

import Foundation

//////////////////////////////////////////////Main notes///////////////////////////////////////////////

let NETWORKS = "Networks"
let ANSWERS = "Answers"
let CATEGORIES = "Categories"
let KEY = "Key"
let QUESTIONS = "Questions"
let USERS = "Users"
let CODEVISECHATTING = "codevise_Chating"
let POSTBOKS = "postboks"
let PUBLISHPOSTS = "publishPosts"

////////////////////////////////////////////// //////////////////////////////////////////////////////////

/////////////////////////////////////////USER TABLE//////////////////////////////////////////////////
let USER_ACTIVITIES_NODE = "Activities"
let USER_FOLLOWACTIVITY = "FollowActivity"
let USER_ACTIVITES = "activities"
let USER_PROFESSION = "profession"
let USER_ACCOUNT_TYPE = "userAccountType"
let USER_ANSWERS = "answers"
let USER_BIO = "bio"
let USER_EMAIL = "email"
let USER_FCM = "fcm"
let USER_FOLLOWERS = "followers"
let USER_FOLLOWING = "following"
let USER_USERId = "id"
let USER_INAPP = "inApp"
let USER_LASTSEEN = "lastSeen"
let USER_PASSWORD = "password"
let USER_DEVICE = "device"
let USER_LIKE_NODE = "like"
let USER_NAME = "name"
let USER_NOTIFICATION = "notification"
let USER_ONLINE = "online"
let USER_PHONE = "phone"
let USER_POSTS = "posts"
let USER_PROFILE = "profile"
let USER_REGION = "region"
let USER_REPLIES = "replies"
let USER_FOLLOW_STATUS = "followerRequestStatus"
let USER_SPECIALISTS = "specialities"
let USER_USERFOLLOWERS_NODE = "userFollowers"
let USER_USERFOLLOWING_NODE = "userFollowing"
let USER_WEBSITE = "website"
let USER_SENT_REQUESTS = "sentFollowerRequest"
let USER_RECIEVED_REQUESTS = "receiveFollowerRequest"

//ACTIVITY Node under user table
//activity node and following activity node are same

let USER_ACTIVITIES_ACTIVITIES = "activities"
let USER_ACTIVITIES_ACTIVITYID = "activityId"
let USER_ACTIVITIES_ANSWERID = "answerId"
let USER_ACTIVITIES_DATE_NODE = "date"
let USER_ACTIVITIES_ID = "id"
let USER_ACTIVITIES_PROFILEPICTURE = "profilePicture"
let USER_ACTIVITIES_QUESTIONID = "questionId"
let USER_ACTIVITIES_USERID = "userId"
let USER_ACTIVITIES_USERNAME = "userName"

/// date Node under user/activities table

// date node under user/activities and user/followingactivities are same

let USER_ACTIVITES_DATE_DATE = "date"
let USER_ACTIVITES_DATE_DAY = "day"
let USER_ACTIVITES_DATE_HOURS = "hours"
let USER_ACTIVITES_DATE_MINUTES = "minutes"
let USER_ACTIVITES_DATE_MONTH = "month"
let USER_ACTIVITES_DATE_SECONDS = "seconds"
let USER_ACTIVITES_DATE_TIME = "time"
let USER_ACTIVITES_DATE_TIMEZONEOFFSET = "timezoneOffset"
let USER_ACTIVITES_DATE_YEAR = "year"
////////////////////////////////////////////// //////////////////////////////////////////////////////////

/////////////////////////////////////////ANSWER TABLE//////////////////////////////////////////////////

let ANSWER_ANSID = "ansId"
let ANSWER_COMMENTS = "comments"
let ANSWER_DATE = "date"
let ANSWER_LIKES = "likes"
let ANSWER_PRIORITY = "priority"
let ANSWER_QUESID = "quesId"
let ANSWER_SELECTED = "selected"
let ANSWER_USERID = "userId"
let ANSWER_VIDEOLINK = "videoLink"
let ANSWER_VIDEOTHUMBLINK = "videoThumbLink"

////////////////////////////////////////////// //////////////////////////////////////////////////////////

/////////////////////////////////////////CATEGORIES TABLE////////////////////////////////////////////////

let CATEGORIES_ANDROID_NODE = "Android"
let CATEGORIES_CODING_NODE = "Coding"
let CATEGORIES_FRONTEND_NODE = "Front End"
let CATEGORIES_GEEKYSTUFF_NODE = "Geeky Stuff"
let CATEGORIES_IOS_NODE = "IOS"
let CATEGORIES_TECHTIPS_NODE = "Tech Tips"
let CATEGORIES_BACKEND_NODE = "Back End"
let CATEGORIES_LANGUAGES_NODE = "Languages"
let CATEGORIES_MARKETING_NODE = "Marketing"
let CATEGORIES_UIUX_NODE = "UI UX"

////////////////////////////////////////////// //////////////////////////////////////////////////////////

/////////////////////////////////////////QUESTION TABLE////////////////////////////////////////////////

let QUESTION_ANSWERS_NODE = "Answers"
let QUESTION_COMMENTS_NODE = "Comments"
let QUESTION_LIKES_NODE = "Likes"
let QUESTION_ANSID = "ansId"
let QUESTION_COMMENTS = "comments"
let QUESTION_DATE = "date"
let QUESTION_LIKES = "likes"
let QUESTION_PRIORITY = "priority"
let QUESTION_QUESID = "quesId"
let QUESTION_TITLE = "title"
let QUESTION_TAGS = "tags"
let QUESTION_SHORTDESCRIPTION = "short_desc"
let QUESTION_CATEGORY = "categroy"
let QUESTION_SELECTED = "selected"
let QUESTION_USERID = "userId"
let QUESTION_VIDEOLINK = "videoLink"
let QUESTION_VIDEOTHUMBLINK = "videoThumbLink"

//ANSWERS Node under QUESTION table
//ANSWER node and ANSWERS table are same except following parameter

let QUESTION_ANSWERS_LIKES_NODE = "Likes"

//COMMENTS Node under QUESTION table

let QUESTION_COMMENTS_COMMENTTIME = "comentTime"
let QUESTION_COMMENTS_COMMENT = "comment"
let QUESTION_COMMENTS_COMMENTID = "commentId"
let QUESTION_COMMENTS_NAME = "name"
let QUESTION_COMMENTS_NUMBER = "number"

/////////////////////////////////////////CODEVISE CHATTING TABLE/////////////////////////////////////////

let CODEVISECHATING_DATE_NODE = "date"
let CODEVISECHATING_DATE1_NODE = "date1"
let CODEVISECHATING_MSG = "msg"
let CODEVISECHATING_MSGID = "msgId"
let CODEVISECHATING_PHOTOURL = "photoUrl"
let CODEVISECHATING_RECEIVER = "receiver"
let CODEVISECHATING_SENDER = "sender"
let CODEVISECHATING_SENT = "sent"
let CODEVISECHATING_STATUS = "status"

/// date Node under CODEVISECHATTING/COMMENTS table

// date node under CODEVISECHATTING/COMMENTS and user/followingactivities are same

////////////////////////////////////////////// //////////////////////////////////////////////////////////

/////////////////////////////////////////KEY TABLE/////////////////////////////////////////

let KEY_KEY = "key"

////////////////////////////////////////////// //////////////////////////////////////////////////////////
//storage constants

let ANSWER_THUMBNAIL_STORAGE = "answerThumb"
let QUESTION_THUMBNAIL_STORAGE = "questionThumb"
let  PROFILE_STORAGE = "profile"
let QUESTION_VIDEO = "questionVideo"
let ANSWER_VIDEO = "answerVideo"
let QUESTION_IMAGE_STORAGE = "uploadImages"

/////


let POSTBOK_MEDIAPATH = "mediaPath"
let POSTBOK_MEDIATYPE = "mediaType"
let POSTBOK_POSTID = "postId"
let POSTBOK_POSTTEXT = "postText"
let POSTBOK_THUMBIMAGE = "videoThumb"

let PUBLISH_MEDIAPATH = "mediaPath"
let PUBLISH_POSTTEXT = "postText"
let PUBLISH_TIMESTAMP = "timestamp"
let PUBLISH_POSTEDON = "postedOn"
let PUBLISH_SCHEDULING = "schedulingon"
let PUBLISH_MEDIATYPE = "mediaType"
let PUBLISH_TWITTER = "twitter"
let PUBLISH_PINTEREST = "pinterest"
let PUBLISH_INSTAGRAM = "instagram"
let PUBLISH_LINKEDIN = "linkedin"
let PUBLISH_FACEBOOK = "facebook"
let PUBLISH_POST_KEY = "key"




let POSTBOK_IMAGE_STORAGE = "postBokImage"
let POSTBOK_THUMBNAIL_STORAGE = "postBokThumb"
let POSTBOK_VIDEO_STORAGE = "postBokVideo"
let PUBLISH_IMAGE_STORAGE = "publishImage"
let PUBLISH_THUMBNAIL_STORAGE = "publishThumb"
