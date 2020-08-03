## Before you start
### Hypervisor Setup
For this workshop you will need a hypervisor installed on your development machine. If you have Windows Hyper-V is preferred; otherwise Oracle VirtualBox is a free cross-platform alternative.
* VirtualBox ([installation instructions](https://www.virtualbox.org/manual/ch02.html))
* Hyper-V (Windows only) ([installation instructions](https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/quick-start/enable-hyper-v))

### Install Vagrant
We will be using a configuration management tool called Vagrant.
* Download page: [vagrantup.com/downloads](https://www.vagrantup.com/downloads)
* Installation instructions: [vagrantup.com/docs/installation](https://www.vagrantup.com/docs/installation)

Once you have installed the version appropriate to your system, check you have access to Vagrant in the shell you are using:
```bash
vagrant --version
```

### Testing SSH
If you haven't yet done so, you should make sure you have created SSH keys and are able to use them to connect to a remote machine.

Github has a comprehensive guide for all major operating systems: [Connecting to Github with SSH](https://docs.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh)