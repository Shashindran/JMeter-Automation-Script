# JMeter-Automation-Script

There are 2 bat scripts.

1. loadtest.bat

   Run test based on user input

3. loadtest-autov2.bat

   Run test by auto increment the thread value by 2 until the TPS drops
   
   
## Usage
### loadtest.bat

1. Prepare working JMeter script (passing).
2. Create a folder called *'Script'* in Desktop and place the script inside the folder.
3. Run the script by double click or using CMD.
4. Input appropriate values. Multiple threads can be passed separated by space. (Eg. 1 3 5 15 25).
5. The result will be generated in html format under *'Reports\<script_name>\<timestamp>\<no_of_thread>'* directory in Desktop


### loadtest-autov2.bat

>NOTE: Make sure jq is installed in the system and able to run jq command from CMD.

1. Prepare working JMeter script (passing). **Make sure no space in the script name**
2. Create a folder called *'Automate'* in Desktop. Inside Automate folder, create a subfolder with the name your wish and place the script inside the subfolder.
3. Run the script from CMD like the following. Script name without .jmx
   ```
   .\loadtest-autov2.bat <script_name> <subfoldername>
   ```
5. The result will be generated in html format under *'Reports\<script_name>\<timestamp>\<no_of_thread>'* directory in Desktop


## Tips
loadtest-autov2.bat can be used with Windows Task Scheduler to schedule a test or series of tests.
