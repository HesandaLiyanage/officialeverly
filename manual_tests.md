# Manual Test Cases

## Hesanda

Test Case 1: Create Memory
Test Case Id: MEMORY-TC-001
Test Case Description: Verify that a user can create a new memory successfully
Preconditions: Application is loaded in browser, user is logged in
Test Data: Memory title, memory date
Steps to execute:
1. Navigate to the create memory page
2. Enter a valid memory title
3. Enter a valid memory date
4. Click the create memory button
5. Verify that the memory is created successfully
Expected Result: The user should be able to create a new memory and view it in the memories list
Actual Result: Entered valid memory details and the new memory was created successfully and displayed in the memories list.
Status: Pass

Test Case 2: View Memory
Test Case Id: MEMORY-TC-002
Test Case Description: Verify that a user can open and view an existing memory
Preconditions: Application is loaded in browser, user is logged in, at least one memory exists
Test Data: Existing memory
Steps to execute:
1. Navigate to the memories page
2. Select an existing memory from the list
3. Open the memory details page
4. Verify that the correct memory information is displayed
Expected Result: The selected memory should open and display its saved details correctly
Actual Result: Opened an existing memory and the saved details were displayed correctly on the memory view page.
Status: Pass

Test Case 3: Update Memory
Test Case Id: MEMORY-TC-003
Test Case Description: Verify that a user can edit and update an existing memory
Preconditions: Application is loaded in browser, user is logged in, at least one memory exists
Test Data: Updated memory title, updated description
Steps to execute:
1. Navigate to the memories page
2. Select an existing memory
3. Click the edit option
4. Update the memory title or description
5. Click the save or update button
6. Verify that the changes are saved successfully
Expected Result: The memory details should be updated and the latest values should be displayed
Actual Result: Updated the memory details and the new values were saved and displayed correctly.
Status: Pass

Test Case 4: Delete Memory
Test Case Id: MEMORY-TC-004
Test Case Description: Verify that a user can delete an existing memory
Preconditions: Application is loaded in browser, user is logged in, at least one memory exists
Test Data: Existing memory
Steps to execute:
1. Navigate to the memories page
2. Select an existing memory
3. Click the delete option
4. Confirm the deletion
5. Verify that the memory is removed from the memories list
Expected Result: The selected memory should be deleted successfully and should no longer appear in the memories list
Actual Result: Deleted the selected memory successfully and it was no longer shown in the memories list.
Status: Pass

Test Case 5: Create Feed Post
Test Case Id: FEED-TC-001
Test Case Description: Verify that a user can create a new feed post successfully
Preconditions: Application is loaded in browser, user is logged in, feed profile is available
Test Data: Valid post caption
Steps to execute:
1. Navigate to the create post page
2. Select a valid memory to post
3. Enter a caption for the post
4. Click the create post button
5. Verify that the post is published to the feed
Expected Result: The user should be able to create a post and see it in the feed
Actual Result: Created a new feed post successfully and it appeared in the feed.
Status: Pass

Test Case 6: View Feed Posts
Test Case Id: FEED-TC-002
Test Case Description: Verify that a user can open the feed page and view available posts
Preconditions: Application is loaded in browser, user is logged in, at least one feed post exists
Test Data: Existing feed posts
Steps to execute:
1. Navigate to the feed page
2. Wait for the page to load completely
3. Observe the list of available feed posts
4. Open a post comments or details view if needed
Expected Result: The feed page should load successfully and display available posts correctly
Actual Result: Opened the feed page successfully and the available posts were displayed correctly.
Status: Pass

Test Case 7: Update Feed Post
Test Case Id: FEED-TC-003
Test Case Description: Verify that a user can update an existing feed post
Preconditions: Application is loaded in browser, user is logged in, at least one feed post exists
Test Data: Updated post caption
Steps to execute:
1. Navigate to the feed or profile page
2. Select an existing post created by the user
3. Click the edit option
4. Update the caption or post details
5. Save the changes
6. Verify that the updated details are displayed
Expected Result: The selected feed post should be updated successfully and display the latest details
Actual Result: Updated the selected feed post and the revised details were displayed correctly.
Status: Pass

Test Case 8: Delete Feed Post
Test Case Id: FEED-TC-004
Test Case Description: Verify that a user can delete an existing feed post
Preconditions: Application is loaded in browser, user is logged in, at least one feed post exists
Test Data: Existing feed post
Steps to execute:
1. Navigate to the feed or profile page
2. Select a post created by the user
3. Click the delete option
4. Confirm the deletion
5. Verify that the post is removed from the feed
Expected Result: The selected feed post should be deleted successfully and should no longer appear in the feed
Actual Result: Deleted the selected feed post successfully and it was removed from the feed.
Status: Pass

## Sinali

Test Case 9: Create Autograph
Test Case Id: AUTOGRAPH-TC-001
Test Case Description: Verify that a user can create a new autograph book successfully
Preconditions: Application is loaded in browser, user is logged in
Test Data: Book title, description
Steps to execute:
1. Navigate to the add autograph page
2. Enter a valid book title
3. Enter a valid description
4. Click the create button
5. Verify that the autograph book is created successfully
Expected Result: The user should be able to create a new autograph book and see it in the autograph list
Actual Result: Entered valid autograph details and the autograph book was created successfully and displayed in the list.
Status: Pass

Test Case 10: View Autograph
Test Case Id: AUTOGRAPH-TC-002
Test Case Description: Verify that a user can open and view an existing autograph book
Preconditions: Application is loaded in browser, user is logged in, at least one autograph exists
Test Data: Existing autograph book
Steps to execute:
1. Navigate to the autograph section
2. Select an existing autograph book
3. Open the autograph details page
4. Verify that the saved autograph details are displayed
Expected Result: The selected autograph book should open and display its details correctly
Actual Result: Opened an existing autograph book and the saved details were displayed correctly.
Status: Pass

Test Case 11: Update Autograph
Test Case Id: AUTOGRAPH-TC-003
Test Case Description: Verify that a user can edit and update an existing autograph book
Preconditions: Application is loaded in browser, user is logged in, at least one autograph exists
Test Data: Updated book title, updated description
Steps to execute:
1. Navigate to the autograph section
2. Select an existing autograph book
3. Click the edit option
4. Update the book title or description
5. Click the update button
6. Verify that the changes are saved successfully
Expected Result: The autograph book details should be updated and the latest values should be displayed
Actual Result: Updated the autograph book details successfully and the latest values were displayed correctly.
Status: Pass

Test Case 12: Delete Autograph
Test Case Id: AUTOGRAPH-TC-004
Test Case Description: Verify that a user can delete an existing autograph book
Preconditions: Application is loaded in browser, user is logged in, at least one autograph exists
Test Data: Existing autograph book
Steps to execute:
1. Navigate to the autograph section
2. Select an existing autograph book
3. Click the delete option
4. Confirm the deletion
5. Verify that the autograph book is removed from the list
Expected Result: The selected autograph book should be deleted successfully and should no longer appear in the autograph list
Actual Result: Deleted the selected autograph book successfully and it was no longer shown in the list.
Status: Pass

Test Case 13: Create Journal
Test Case Id: JOURNAL-TC-001
Test Case Description: Verify that a user can create a new journal entry successfully
Preconditions: Application is loaded in browser, user is logged in
Test Data: Journal content
Steps to execute:
1. Navigate to the write journal page
2. Enter valid journal content
3. Click the save or create button
4. Verify that the journal entry is created successfully
Expected Result: The user should be able to create a new journal entry and see it in the journals list
Actual Result: Created a new journal entry successfully and it appeared in the journals list.
Status: Pass

Test Case 14: View Journal
Test Case Id: JOURNAL-TC-002
Test Case Description: Verify that a user can open and view an existing journal entry
Preconditions: Application is loaded in browser, user is logged in, at least one journal exists
Test Data: Existing journal entry
Steps to execute:
1. Navigate to the journals page
2. Select an existing journal entry
3. Open the journal details page
4. Verify that the journal content is displayed correctly
Expected Result: The selected journal entry should open and display its saved content correctly
Actual Result: Opened an existing journal entry and the saved content was displayed correctly.
Status: Pass

Test Case 15: Update Journal
Test Case Id: JOURNAL-TC-003
Test Case Description: Verify that a user can edit and update an existing journal entry
Preconditions: Application is loaded in browser, user is logged in, at least one journal exists
Test Data: Updated journal title, updated content
Steps to execute:
1. Navigate to the journals page
2. Select an existing journal entry
3. Click the edit option
4. Update the title or content
5. Click the save or update button
6. Verify that the updated details are displayed
Expected Result: The selected journal entry should be updated successfully and show the latest details
Actual Result: Updated the selected journal entry successfully and the latest details were displayed correctly.
Status: Pass

Test Case 16: Delete Journal
Test Case Id: JOURNAL-TC-004
Test Case Description: Verify that a user can delete an existing journal entry
Preconditions: Application is loaded in browser, user is logged in, at least one journal exists
Test Data: Existing journal entry
Steps to execute:
1. Navigate to the journals page
2. Select an existing journal entry
3. Click the delete option
4. Confirm the deletion
5. Verify that the journal entry is removed from the journals list
Expected Result: The selected journal entry should be deleted successfully and should no longer appear in the journals list
Actual Result: Deleted the selected journal entry successfully and it was removed from the journals list.
Status: Pass

## Nishaka

Test Case 17: Create Group
Test Case Id: GROUP-TC-001
Test Case Description: Verify that a user can create a new group successfully
Preconditions: Application is loaded in browser, user is logged in
Test Data: Group name, group description
Steps to execute:
1. Navigate to the create group page
2. Enter a valid group name
3. Enter a valid group description
4. Click the create group button
5. Verify that the group is created successfully
Expected Result: The user should be able to create a new group and see it in the groups list
Actual Result: Entered valid group details and the new group was created successfully and displayed in the groups list.
Status: Pass

Test Case 18: View Group
Test Case Id: GROUP-TC-002
Test Case Description: Verify that a user can open and view an existing group
Preconditions: Application is loaded in browser, user is logged in, at least one group exists
Test Data: Existing group
Steps to execute:
1. Navigate to the groups page
2. Select an existing group
3. Open the group details page
4. Verify that the saved group details are displayed correctly
Expected Result: The selected group should open and display its details correctly
Actual Result: Opened an existing group successfully and its saved details were displayed correctly.
Status: Pass

Test Case 19: Update Group
Test Case Id: GROUP-TC-003
Test Case Description: Verify that a user can edit and update an existing group
Preconditions: Application is loaded in browser, user is logged in, at least one group exists
Test Data: Updated group name, updated group description
Steps to execute:
1. Navigate to the groups page
2. Select an existing group
3. Click the edit option
4. Update the group name or description
5. Click the update button
6. Verify that the updated details are displayed
Expected Result: The selected group should be updated successfully and show the latest details
Actual Result: Updated the selected group successfully and the latest details were displayed correctly.
Status: Pass

Test Case 20: Delete Group
Test Case Id: GROUP-TC-004
Test Case Description: Verify that a user can delete an existing group
Preconditions: Application is loaded in browser, user is logged in, at least one group exists
Test Data: Existing group
Steps to execute:
1. Navigate to the groups page
2. Select an existing group
3. Click the delete option
4. Confirm the deletion
5. Verify that the group is removed from the groups list
Expected Result: The selected group should be deleted successfully and should no longer appear in the groups list
Actual Result: Deleted the selected group successfully and it was no longer shown in the groups list.
Status: Pass

Test Case 21: Create Event
Test Case Id: EVENT-TC-001
Test Case Description: Verify that a user can create a new event successfully
Preconditions: Application is loaded in browser, user is logged in
Test Data: Event title, event description, event date
Steps to execute:
1. Navigate to the create event page
2. Enter a valid event title
3. Enter a valid event description
4. Enter a valid event date
5. Click the create event button
6. Verify that the event is created successfully
Expected Result: The user should be able to create a new event and see it in the events list
Actual Result: Entered valid event details and the new event was created successfully and displayed in the events list.
Status: Pass

Test Case 22: View Event
Test Case Id: EVENT-TC-002
Test Case Description: Verify that a user can open and view an existing event
Preconditions: Application is loaded in browser, user is logged in, at least one event exists
Test Data: Existing event
Steps to execute:
1. Navigate to the events page
2. Select an existing event
3. Open the event details page
4. Verify that the saved event details are displayed correctly
Expected Result: The selected event should open and display its details correctly
Actual Result: Opened an existing event successfully and its saved details were displayed correctly.
Status: Pass

Test Case 23: Update Event
Test Case Id: EVENT-TC-003
Test Case Description: Verify that a user can edit and update an existing event
Preconditions: Application is loaded in browser, user is logged in, at least one event exists
Test Data: Updated event title, updated description, updated date
Steps to execute:
1. Navigate to the events page
2. Select an existing event
3. Click the edit option
4. Update the event title, description, or date
5. Click the update button
6. Verify that the updated details are displayed
Expected Result: The selected event should be updated successfully and show the latest details
Actual Result: Updated the selected event successfully and the latest details were displayed correctly.
Status: Pass

Test Case 24: Delete Event
Test Case Id: EVENT-TC-004
Test Case Description: Verify that a user can delete an existing event
Preconditions: Application is loaded in browser, user is logged in, at least one event exists
Test Data: Existing event
Steps to execute:
1. Navigate to the events page
2. Select an existing event
3. Click the delete option
4. Confirm the deletion
5. Verify that the event is removed from the events list
Expected Result: The selected event should be deleted successfully and should no longer appear in the events list
Actual Result: Deleted the selected event successfully and it was removed from the events list.
Status: Pass

## Anushan

Test Case 25: View Admin Dashboard
Test Case Id: ADMIN-TC-001
Test Case Description: Verify that an admin user can open the admin dashboard successfully
Preconditions: Application is loaded in browser, admin user is logged in
Test Data: Valid admin account
Steps to execute:
1. Log in using an admin account
2. Navigate to the admin dashboard
3. Observe the dashboard sections and summary details
4. Verify that the admin dashboard loads correctly
Expected Result: The admin dashboard should open successfully and display the available admin sections
Actual Result: Logged in as an admin and the admin dashboard loaded successfully with the expected sections.
Status: Pass

Test Case 26: View User Management in Admin Panel
Test Case Id: ADMIN-TC-002
Test Case Description: Verify that an admin user can open the user management section and view registered users
Preconditions: Application is loaded in browser, admin user is logged in, user records exist
Test Data: Existing registered users
Steps to execute:
1. Log in using an admin account
2. Navigate to the admin user management page
3. Observe the list of users
4. Verify that user details are displayed correctly
Expected Result: The admin should be able to view the registered users in the user management section
Actual Result: Opened the user management page successfully and the registered users were displayed correctly.
Status: Pass

Test Case 27: Update User Status in Admin Panel
Test Case Id: ADMIN-TC-003
Test Case Description: Verify that an admin user can update the status of a user account
Preconditions: Application is loaded in browser, admin user is logged in, at least one user account exists
Test Data: Existing user account
Steps to execute:
1. Log in using an admin account
2. Navigate to the admin user management page
3. Select a user account
4. Click the activate or deactivate option
5. Verify that the user status is updated successfully
Expected Result: The admin should be able to update the selected user account status successfully
Actual Result: Updated the selected user account status successfully and the new status was reflected correctly.
Status: Pass

Test Case 28: Handle Reported Posts in Admin Panel
Test Case Id: ADMIN-TC-004
Test Case Description: Verify that an admin user can view and handle reported posts from the admin content section
Preconditions: Application is loaded in browser, admin user is logged in, at least one reported post exists
Test Data: Reported post
Steps to execute:
1. Log in using an admin account
2. Navigate to the admin content management page
3. View the list of reported posts
4. Select a reported post
5. Perform an action such as mark reviewed, dismiss, or delete post
6. Verify that the selected action is applied successfully
Expected Result: The admin should be able to view reported posts and apply the selected action successfully
Actual Result: Viewed the reported posts successfully and applied the selected action without any issue.
Status: Pass
