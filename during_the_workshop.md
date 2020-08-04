## Workshop Instructions

### SSH to your VM

* You should have been provided with a **hostname** for a remote VM and some **credentials**.
* Use these credentials to connect to your VM over ssh.

```bash
  ssh user@hostname
```

You should now be connected to the remote VM. Try a few simple shell commands to confirm you're connected.

To make ssh easier you should add your **public key** to the `authorized_keys` file on the remote VM.

```bash
# Opening the authorized_keys file for editing
vi ~/.ssh/authorized_keys
```

### Getting started with Chimera
The VM has a, partially, working version of Chimera on it. If you navigate to the URL provided by your trainer you should be able to see the page it produces. The `webapp` part appears to be functioning correctly, you should leave it alone.

On the VM you should be able to find `cliapp`. This is a command line program that you should be able to run like so:

```bash
cliapp --version
```

This should print the version number of the program to the console. If you see this, you can move onto the next section.

### Input Data
If you run `cliapp` without any arguments it will print its output to the console. You should see something like this:

```json
{
  "datasetName": "edge-throw-except",
  "data": [],
  "generationTime": 1596458170057,
  "centre": "[0, 0]",
  "zoom": null
}
```

This is an empty dataset with a randomly generated name. To produce a useful dataset we need to provide an input file in the correct format.

Create a new file using the `touch` command and pass it to `cliapp` using the `-i` flag.

```bash
touch some_file_name
cliapp -i some_file_name
```

The result should be very similar to running the program without any arguments. This isn't surprising as our input file is currently blank.

Open your input file using `vi` and add the following line and run `cliapp` again. What happens?
```bash
59.0916|-137.8717|111 km WSW of Covenant Life, Alaska|6.4
```

Hopefully `cliapp` should have generated a non-empty dataset. If you copy the dataset name and paste it onto the end of your URI in your web browser you should see something on the map.

```bash
https://{hostname>/{datasetName}
```

### Data Manipulation
Now we know how to feed data into Chimera we need to work out how to do this more efficiently.

We want to use [USGS](https://earthquake.usgs.gov/earthquakes/feed/v1.0/geojson.php) as our source. They have various regularly updated feeds. Start off using the [hourly feed](https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_hour.geojson). We need to write a script to convert this data to the pipe delimited format that `cliapp` can read.

#### Tips
* Use `curl` to save a copy of the JSON feed locally (it's quicker than downloading it everytime.)
* The command line program `jq` is very useful for manipulating JSON data. You can find it's manual [here](https://stedolan.github.io/jq/manual/)

### Automation Part 1
When you've written your script we need to automate it. You'll want to use `crontab` to call the script.

We've got some requirements from the CEO:
* The "last hour" dataset should be regenerated every five minutes.
* The dataset should include the date and time it was generated in its name.
* Using `latest` should always return the latest hourly dataset.
* All hourly datasets for the last 24 hours should also be kept accessible.
* Any hourly datasets older than 24 hours should be automatically deleted.

### Creating a local environment

Now you've got the CEO happy it's time to start creating a local development environment. We've started you off by creating a skeleton [Vagrantfile](./VagrantFile) with some hints as to what different steps there are.

You'll want to copy `webapp` and `cliapp` from your remote VM to use in your local environment.

Hint: `scp` might be a helpful program for copying files from a remote machine.

### Automation Part 2
The CEO has come back with some more requirements for you.

* At midnight everyday the script should create a summary of the last 24 hours. It should be called `yesterday`.
* Every hour during the day a new dataset called `today` should be produced. It should show all earthquakes since the most recent midnight.

#### Hints
* The USGS has more than just the hourly data feed.
* You might want to add some parameters to your script, if you haven't already.

### Document `cliapp`

If you run `cliapp --help` you'll see lots of different options that can be passed to the program. We've documented some of these in [cliapp_reference.md](./cliapp_reference.md) but some are a complete mystery.

Can you work out what they do and complete the documentation?
