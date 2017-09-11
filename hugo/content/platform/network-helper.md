---
deprecated: false
author:
  name: Alex Fornuto
  email: docs@linode.com
description: 'Information on the Network Helper option.'
keywords: 'network, networking, network helper, ip, ip address, static ip,'
license: '[CC BY-ND 4.0](https://creativecommons.org/licenses/by-nd/4.0)'
modified: Friday, April 28, 2017
modified_by:
  name: Linode
published: ''
title: Network Helper
---

Network Helper automatically deposits a static networking configuration in to your Linode at boot. Thanks to Network Helper, you don't have to worry about altering your network configuration when you:

 - Deploy a Linode
 - Add a public or private IPv4 address
 - Restore from a backup
 - Deploy from an Linode Images template
 - Migrate your Linode to a new datacenter
 - Clone from another Linode


{: .note }
> If you intend to manually configure IPv6 addresses from a supplied pool, you should [disable](/docs/networking/linux-static-ip-configuration#disable-network-helper) Network Helper so that it doesn't overwrite your configuration file on reboot. Please see our [Native IPv6 Networking](/docs/networking/native-ipv6-networking) guide for more information on IPv6. 

## What Does It Do?

On enabled profiles, the Network Helper works by detecting which distribution is booting, and modifies the appropriate configuration files to assign the IPv4 address statically. [Click Here](#what-files-are-affected) to jump to the list of distribution-specific files.

{: .caution}
>If you create an advanced configuration, Network Helper will undo those changes at the next boot. For advanced configurations, turn off Network Helper.

## Turn Network Helper On for Individual Configuration Profiles.

Even with the global setting for Network Helper set to **OFF**, you can enable Network Helper on specific configuration profiles.

1.  Go to your Linode's Dashboard, and under Configuration Profiles click **Edit** for the profile you want to adjust:

    [![The Edit link for a Configuration Profile](/docs/assets/linode-dashboard-hilighted_small.png)](/docs/assets/linode-dashboard-hilighted.png)

2.  Under the Filesystem/Boot Helpers section, change the **Auto-Configure Networking** option to Yes:


    [![The Auto-configure Networking option](/docs/assets/network-helper-hilighted_small.png)](/docs/assets/network-helper-hilighted.png)

3. Click on **Save Changes**.

## What Files are Affected

You will retain 3 versions of each file modified by Network Helper after each boot. Consider Debian for this example. Below is an example network configuration file for a Debian 7 Linode with Network Helper enabled:

{: .file}
/etc/network/interfaces
:   ~~~
    # Generated by Linode Network Helper
    # Thu Dec  4 20:24:07 2014 UTC
    #
    # This file is automatically generated on each boot with your Linode's
    # current network configuration. If you need to modify this file, please
    # first disable the 'Auto-configure Networking' setting within your Linode's
    # configuration profile:
    #  - https://manager.linode.com/linodes/config/web1?id=123456
    #
    # For more information on Network Helper:
    #  - https://www.linode.com/docs/platform/network-helper
    #
    # A backup of the previous config is at /etc/network/.interfaces.linode-last
    # A backup of the original config is at /etc/network/.interfaces.linode-orig
    #
    # /etc/network/interfaces

    auto lo
    iface lo inet loopback

    auto eth0
    allow-hotplug eth0

    iface eth0 inet6 auto

    iface eth0 inet static
        address 198.74.53.231/24
        gateway 198.74.53.1
        up   ip addr add 12.34.56.78/24 dev eth0 label eth0:1
        down ip addr del 12.34.56.78/24 dev eth0 label eth0:1
        up   ip addr add 192.168.138.44/17 dev eth0 label eth0:2
        down ip addr del 192.168.138.44/17 dev eth0 label eth0:2
    ~~~

In addition to the `/etc/network/interfaces` file, Network Helper will create:

- A copy of the file as the distribution provided it: `.interfaces.linode-orig`.

- A copy of the file from the previous boot: `.interfaces.linode-last`. If you made manual changes to the file during the previous boot, you'll find them saved here.

If you need to restore manual changes made during a previous reboot, use the following command (replacing `/etc/network/interfaces` with the files for your specific distribution):

    mv /etc/network/.interfaces.linode-last /etc/network/interfaces

If you'd like to know what files Network Helper modifies specifically, scroll down to your preferred distribution.

###Debian & Ubuntu

Network helper configures `/etc/network/interfaces` & `/etc/resolv.conf`.

### CentOS & Fedora

Network Helper configures `/etc/sysconfig/network-scripts/ifcfg-eth0`.

### Arch

Network Helper configures `/etc/systemd/network/05-eth0.network`.

### Gentoo

Network Helper configures `/etc/conf.d/net` & `/etc/resolv.conf`.

### OpenSUSE

Network Helper configures `/etc/sysconfig/network/ifcfg-eth0`, `/etc/sysconfig/network/routes` & `/etc/resolv.conf`.

###Slackware

Network Helper configures `/etc/rc.d/rc.inet1.conf` & `/etc/resolv.conf`.

## Failure to Run

If Network Helper is unable to determine the operating system during boot, it will not attempt to write any new configuration files. When this happens, Network Helper will let you know in the Host Job Queue:

[![Network Helper Failure Message](/docs/assets/network-helper-failure_small.png)](/docs/assets/network-helper-failure.png)

Similarly, if you boot an unsupported older distribution while Network Helper is enabled, you'll see a warning in the Host Job Queue:

[![Network Helper Failure Message](/docs/assets/network-helper-unsupported_small.png)](/docs/assets/network-helper-unsupported.png)

##Modify Global Network Helper Settings

Network helper is enabled on all new configuration profiles by default. To modify this behavior as default follow the steps below.

1.  From the Linode Manager, click on the **Account** tab:

    ![The Account tab in the Linode Manager](/docs/assets/account-tab.png)

2.  Click on the **Account Settings** tab. You can modify the default behavior under the network helper section:

    [![The Network Helper Default Behavior option](/docs/assets/account-settings_small.png)](/docs/assets/account-settings.png)

3. Click the **Save** button.