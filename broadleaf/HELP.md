# Broadleaf Manifest Initializr
Welcome to Broadleaf Microservices! This is the primary starting point for developers
to create, manage, and evolve a Broadleaf Microservices project. This project
allows you to dynamically build a project structure based on configurations specified
in a `manifest.yml` file. Not only does this project allow you to build out
an initial project structure, it also supports changes to an already generated project
to support evolving implementation needs over time.

## Manifest Project Structure
The manifest project structure is relatively simple and consists of two primary parts:

1. a `pom.xml` that inherits from `broadleaf-microservices-flex-parent`
2. a `src/main/resources/manifest.yml` file - the main configuration file used in generating project resources

> NOTE: If you downloaded this project from
[https://start.broadleafcommerce.com](https://start.broadleafcommerce.com), your manifest
has already been pre-configured with the appropriate settings based on the input you
provided through the web initializr interface.

## What Else Do I Need?
In order to generate a project from this manifest, you will want to obtain and install the following:

### Credentials
Access to Broadleaf's Docker Registry and Maven Nexus is needed in order to pull down the
appropriate resources. Once you have obtained these credentials, you will need to configure them for the dependencies
below.

> NOTE: If you already have an Enterprise License, proceed with the instructions below.
If you do not have an Enterprise License, you can request [free limited use developer evaluation credentials here](https://www.broadleafcommerce.com/developer-evaluation).
For more information about Broadleaf's Enterprise Licenses [reach out to us here](https://www.broadleafcommerce.com/contact).

#### Evaluation Credentials vs Enterprise License Credentials
If you've signed up for a [free developer evaluation trial](http://www.broadleafcommerce.com/developer-evaluation),
you should receive an email with getting started instructions that include a `username`, `password`, and an `expiration date`.

You should be aware that there are slightly different "Getting Started" steps that are only
applicable to Evaluation Credentials. As you are following any of the getting started guides
on this portal, **make sure to pay attention to any instructions that callout different steps
needed for "Evaluation Credential Holders"**.

> TIP: a list of all the differentiated steps between Enterprise License Credentials vs Evaluation Credentials can be found on [this page](https://developer.broadleafcommerce.com/starter-projects/evaluation-credentials)

#### How do I know if I have evaluation credentials?
You have evaluation credentials if:

- You've signed up yourself directly [here](http://www.broadleafcommerce.com/developer-evaluation)
- You've received a `username` that starts with `eval-`

### Java
You will need Java 17 installed on your machine. See more details about
[supported Java versions](https://developer.broadleafcommerce.com/architecture/tech-stack#faq) on our Developer Portal.

### Docker
You will need to have [Docker Engine & Docker Compose](https://docs.docker.com/install/) installed
locally.

> TIP: Docker Desktop for both Mac and Windows already includes compose along with other docker apps.

Once you have docker installed, you will want to authenticate with Broadleaf's docker registry.
Type the following into your CLI:

*For Enterprise License Holders:*
```script
docker login repository.broadleafcommerce.com:5001
```

*For Evaluation Credential Holders:*
```script
docker login https://evaluation.docker.blcdemo.com
```

When prompted, type in the username and password you received above.

### OpenSSL
OpenSSL is used to perform cryptographic operations during project generation and is responsible for several key 
security artifacts. One of the easiest ways to get OpenSSL installed is by including it during a git installation:
[Install Git](https://github.com/git-guides/install-git). Otherwise, you may install OpenSSL directly using whatever
method makes the most sense.

> NOTE: You may need to add the directory containing the OpenSSL executable to your path. In the end, you should be able
> to execute this command and see similar results. We have primarily tested with versions >= 3.1.x, and your mileage may
> vary with earlier versions.

```script
> openssl version
OpenSSL 3.1.4 24 Oct 2023 (Library: OpenSSL 3.1.4 24 Oct 2023)
```
### Maven Configuration
Broadleaf uses the popular open-source build tool Maven to build and launch the Broadleaf
Microservices projects. The manifest project you downloaded, comes pre-bundled with a
Maven executable called the [Maven Wrapper](https://maven.apache.org/wrapper/).
You can also install Maven directly. If so, we recommend installing
[Maven 3.5 or later](https://maven.apache.org/download.cgi).

Once you have maven, you will need to configure authentication for Broadleaf.
Maven requires authentication to be specified in a
file called `settings.xml` in your `.m2` subdirectory (typically found in a user’s home directory).
More details on [configuring Maven](https://maven.apache.org/settings.html) can be found on the [official Maven documentation](https://maven.apache.org/index.html).

Typical Configuration Steps Include:
1. Creating a folder called `.m2` in your home directory (if one does not already exist)
2. Creating a file called `settings.xml` in the `.m2` folder (if not there already)
3. Copy the following contents to your `~/.m2/settings.xml` servers section, making sure to
replace the credentials with the ones you received above:

*For Enterprise License Holders:*
```xml
<settings xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.1.0 http://maven.apache.org/xsd/settings-1.1.0.xsd"
          xmlns="http://maven.apache.org/SETTINGS/1.1.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <servers>
        <server>
            <id>broadleaf-microservices</id>
            <username>username_here</username>
            <password>password_here</password>
        </server>
    </servers>
</settings>
```

*For Evaluation Credential Holders:*
```xml
<settings xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.1.0 http://maven.apache.org/xsd/settings-1.1.0.xsd"
          xmlns="http://maven.apache.org/SETTINGS/1.1.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <servers>
        <server>
            <id>broadleaf-microservices-evaluation</id>
            <username>eval_username_here</username>
            <password>eval_password_here</password>
        </server>
    </servers>
    <mirrors>
        <mirror>
            <id>broadleaf-microservices-evaluation</id>
            <mirrorOf>broadleaf-microservices</mirrorOf>
            <url>https://evaluation.repository.blcdemo.com/repository/microservices/</url>
        </mirror>
    </mirrors>
</settings>
```

> NOTE: the rest of the HELP.md guide will assume the use of the Maven Wrapper (i.e. `./mvnw`) in
the root of the `manifest` project going forward. Feel free to use `mvn` directly if you already
have a maven installation configured on your machine.

## Generating Your Project
Now that you have your manifest configured, you can run the following maven command to generate
your project structure from the `manifest` root directory.

```
./mvnw clean install flex:generate
```

### Flex Maven Plugin Details
- Broadleaf provides a Maven Plugin called the "flex" plugin to look at the properties set in your
manifest and generate you the appropriate project structure.
- When executing the `flex:generate` maven plugin, it will emit detailed logging about what is
created, added, or removed in regard to projects and pom files directly to the console.
- By default, this maven plugin will generate the appropriate Broadleaf Flex Package project
structures at the same directory level as the overall manifest root folder.
- You can run `./mvnw flex:help` for more available configuration options

### Balanced Flex Composition
If you specified `Balanced` as your chosen Flex Package composition, you should have the following new project directories
created: `auth`, `browse`, `cart`, `data`, `processing`, and `supporting` after running `flex:generate`.
Each of these generated Flex Package projects are Spring Boot projects containing the appropriate mix of
Broadleaf Microservices which can be run and started as a single unit.

```
project
│   pom.xml <------ Generated Loose Binding POM
│
└── manifest
│   │   pom.xml
│   │   HELP.md
│   │   ...
│   └── src / main / resources
│       │   manifest.yml
│
└── auth <------ Generated Auth Project Folder
└── browse <------ Generated Browse Project Folder
└── cart <------ Generated Cart Project Folder
└── data <------ Generated Data Project Folder
└── processing <------ Generated Processing Project Folder
└── supporting <------ Generated Supporting Project Folder
└── security <------ Generated Security Folder
└── config <------ Generated Config Properties Folder (if ConfigServer was enabled)
```

### One/Mono Flex Composition (Local Development and Evaluation Purposes Only)
If you specified `Mono` as your chosen Flex Package composition, you should have the following new project directories
created: `auth`, `one`, and `data` after running `flex:generate`.
Each of these generated Flex Package projects are Spring Boot projects containing the appropriate mix of
Broadleaf Microservices which can be run and started as a single unit.

```
project
│   pom.xml <------ Generated Loose Binding POM
│
└── manifest
│   │   pom.xml
│   │   HELP.md
│   │   ...
│   └── src / main / resources
│       │   manifest.yml
│
└── auth <------ Generated Auth Project Folder
└── one <------ Generated One Project Folder
└── data <------ Generated Data Project Folder
└── security <------ Generated Security Folder
└── config <------ Generated Config Properties Folder (if ConfigServer was enabled)
```

## Build and Run Your Projects
After you've generated your Flex Package projects, you're ready to build and launch your applications.

### Step 1: Build All Projects using Maven
From the root of the manifest directory, run the following maven command:

```
./mvnw clean install -f ../
```

This will tell maven to look at the generated "Loose Binding Pom" produced above and build
all the "subprojects" that have been defined in that `pom.xml`.

> NOTE: running this for the first time may take some time to fully complete as your system will need
to download all the project dependencies. Once dependencies have been downloaded, subsequent
builds should be much faster as those artifacts will be readily available in your local maven repository
(i.e. in your `~/.m2/repository` directory).

### Step 2: Generate Docker Compose Files
This project also allows you to generate the appropriate `docker-compose.yml` files based
on the configurations specified in your `manifest.yml` file. The docker compose definition
will define the supporting container services that are necessary in order to run and experience the
full-suite of Broadleaf Microservices. This will include things like: zookeeper, a messaging broker,
a database, a search engine, etc...

You can run the following command to generate the appropriate `docker-compose.yml` files.
From the root of the manifest directory, run the following maven command:

*For Enterprise License Holders:*
```
./mvnw docker-compose:generate
```

*For Evaluation Credential Holders:*
```
./mvnw docker-compose:generate -Dmirror=evaluation.docker.blcdemo.com
```

#### Docker Compose Maven Plugin Details
- The `docker-compose:generate` maven plugin generates a `docker-compose.yml` file
in the `target/docker` directory of your manifest project by default.
- You can run `./mvnw docker-compose:help` for more available configuration options

### Step 3: Launch Supporting Containers
Next, in order to bootstrap the infrastructure needed by the microservices, we'll want to
launch all the supporting containers using the generated `docker-compose.yml` files.
From the root of the manifest directory, run the following maven command to start up all the
supporting containers:

*For Enterprise License Holders:*
```
./mvnw docker-compose:up
# similarly, you can also invoke "./mvnw docker-compose:down" to shut down the containers
```

*For Evaluation Credential Holders:*
```
./mvnw docker-compose:up -Dmirror=evaluation.docker.blcdemo.com
# similarly, you can also invoke "./mvnw docker-compose:down -Dmirror=evaluation.docker.blcdemo.com" to shut down the containers
```

> NOTE: It is advised to check that all the docker containers started up appropriately and
are running. If any of them are not, you may want to execute `./mvnw docker-compose:up` again
and check that you have allocated appropriate resources to your docker daemon.

### Starting the Services

> IMPORTANT: there are known limitations with using the Maven Spring Boot Plugin and Windows
command length restrictions. More details can be found [here](https://ms-support.broadleafcommerce.com/article/74-windows-filename-or-extension-is-too-long).
When working in Windows, you may initiate the project using the executable JAR method, which is demonstrated
> below. Linux and Mac are less restricted and may leverage the maven spring boot plugin for easier command
> line launching. **_However, for real development workflows in any OS, we recommend launching directly from your IDE._** 
> See [IntelliJ Setup](https://developer.broadleafcommerce.com/starter-projects/intellij-setup) for more information.

### Step 4: Initialize the Database

You will notice that the `flex:generate` command also produced a `data` project as part of the
generation process. This project is a standalone Spring Command Line runner project that
is responsible for initializing the database with the schema and structures needed for
all the microservices.

> The `data` module can run in both a headless and non-headless mode.
When not running in headless-mode, you will be prompted to reply with 'Y' or 'N'
in order to confirm updates to the target database and schemas. Type 'Y' when ready.

From the root of the `manifest` directory, run:

#### Quickstart: Data Module (MacOS/Linux)

```
./mvnw spring-boot:run -f ../data
```

#### Quickstart: Data Module (Windows)

```
java -jar ..\data\target\microservice-ingestion-data-1.0.0-SNAPSHOT.jar --spring.cloud.bootstrap.enabled=true
```

### Step 5: Launch all the Commerce Flex Packages
Finally, you'll want to launch all the generated Flex Package projects.

> NOTE: If you've chosen to extend certain Broadleaf services (i.e. you've `enabled`
specific service `components` in the manifest), then you will notice that the manifest also
generated individual project structures for each of those services needing customization.
For example, you may see additional projects like `catalogComponent` and `pricingComponent` etc...
These extensions will build JARs which are included in the appropriate Flex Package.

To build and start each Flex Package project from the `manifest` root directory,
you can run the following commands to start up each of these modules in a new terminal.

#### Quickstart: Balanced Config (MacOS / Linux)
If you've chosen the `Balanced` Flex Package, run the following
maven commands (in separate terminal sessions) from the root of the `manifest` directory:

```
./mvnw spring-boot:run -f ../auth
./mvnw spring-boot:run -f ../supporting
./mvnw spring-boot:run -f ../browse
./mvnw spring-boot:run -f ../cart
./mvnw spring-boot:run -f ../processing
```

#### Quickstart: One/Mono Config (MacOS / Linux)
If you've chosen the `Mono` Flex Package, run the following
maven commands (in separate terminal sessions) from the root of the `manifest` directory:

```
./mvnw spring-boot:run -f ../auth
./mvnw spring-boot:run -f ../one
```

#### Quickstart: Balanced Config (Windows)
If you've chosen the `Balanced` Flex Package, run the following
maven commands (in separate terminal sessions) from the root of the `manifest` directory:

##### PowerShell
```
$env:BROADLEAF_SECURE_ENV_DIR_PATH="[absolute path to the 'security' directory in your project]"
java --add-opens=jdk.management/com.sun.management.internal=ALL-UNNAMED --add-opens=java.base/jdk.internal.misc=ALL-UNNAMED --add-opens=java.base/sun.nio.ch=ALL-UNNAMED --add-opens=java.management/com.sun.jmx.mbeanserver=ALL-UNNAMED --add-opens=jdk.internal.jvmstat/sun.jvmstat.monitor=ALL-UNNAMED --add-opens=java.base/sun.reflect.generics.reflectiveObjects=ALL-UNNAMED --add-opens=java.base/java.io=ALL-UNNAMED --add-opens=java.base/java.nio=ALL-UNNAMED --add-opens=java.base/java.util=ALL-UNNAMED --add-opens=java.base/java.lang=ALL-UNNAMED --add-opens=java.base/java.lang.reflect=ALL-UNNAMED --add-opens=java.base/java.lang.invoke=ALL-UNNAMED --add-opens=java.base/java.time=ALL-UNNAMED --add-opens=java.base/java.time.format=ALL-UNNAMED -jar ..\auth\target\microservice-flexpackage-auth-1.0.0-SNAPSHOT.jar --spring.cloud.bootstrap.enabled=true
java --add-opens=jdk.management/com.sun.management.internal=ALL-UNNAMED --add-opens=java.base/jdk.internal.misc=ALL-UNNAMED --add-opens=java.base/sun.nio.ch=ALL-UNNAMED --add-opens=java.management/com.sun.jmx.mbeanserver=ALL-UNNAMED --add-opens=jdk.internal.jvmstat/sun.jvmstat.monitor=ALL-UNNAMED --add-opens=java.base/sun.reflect.generics.reflectiveObjects=ALL-UNNAMED --add-opens=java.base/java.io=ALL-UNNAMED --add-opens=java.base/java.nio=ALL-UNNAMED --add-opens=java.base/java.util=ALL-UNNAMED --add-opens=java.base/java.lang=ALL-UNNAMED --add-opens=java.base/java.lang.reflect=ALL-UNNAMED --add-opens=java.base/java.lang.invoke=ALL-UNNAMED --add-opens=java.base/java.time=ALL-UNNAMED --add-opens=java.base/java.time.format=ALL-UNNAMED -jar ..\supporting\target\microservice-flexpackage-supporting-1.0.0-SNAPSHOT.jar --spring.cloud.bootstrap.enabled=true
java --add-opens=jdk.management/com.sun.management.internal=ALL-UNNAMED --add-opens=java.base/jdk.internal.misc=ALL-UNNAMED --add-opens=java.base/sun.nio.ch=ALL-UNNAMED --add-opens=java.management/com.sun.jmx.mbeanserver=ALL-UNNAMED --add-opens=jdk.internal.jvmstat/sun.jvmstat.monitor=ALL-UNNAMED --add-opens=java.base/sun.reflect.generics.reflectiveObjects=ALL-UNNAMED --add-opens=java.base/java.io=ALL-UNNAMED --add-opens=java.base/java.nio=ALL-UNNAMED --add-opens=java.base/java.util=ALL-UNNAMED --add-opens=java.base/java.lang=ALL-UNNAMED --add-opens=java.base/java.lang.reflect=ALL-UNNAMED --add-opens=java.base/java.lang.invoke=ALL-UNNAMED --add-opens=java.base/java.time=ALL-UNNAMED --add-opens=java.base/java.time.format=ALL-UNNAMED -jar ..\browse\target\microservice-flexpackage-browse-1.0.0-SNAPSHOT.jar --spring.cloud.bootstrap.enabled=true
java --add-opens=jdk.management/com.sun.management.internal=ALL-UNNAMED --add-opens=java.base/jdk.internal.misc=ALL-UNNAMED --add-opens=java.base/sun.nio.ch=ALL-UNNAMED --add-opens=java.management/com.sun.jmx.mbeanserver=ALL-UNNAMED --add-opens=jdk.internal.jvmstat/sun.jvmstat.monitor=ALL-UNNAMED --add-opens=java.base/sun.reflect.generics.reflectiveObjects=ALL-UNNAMED --add-opens=java.base/java.io=ALL-UNNAMED --add-opens=java.base/java.nio=ALL-UNNAMED --add-opens=java.base/java.util=ALL-UNNAMED --add-opens=java.base/java.lang=ALL-UNNAMED --add-opens=java.base/java.lang.reflect=ALL-UNNAMED --add-opens=java.base/java.lang.invoke=ALL-UNNAMED --add-opens=java.base/java.time=ALL-UNNAMED --add-opens=java.base/java.time.format=ALL-UNNAMED -jar ..\cart\target\microservice-flexpackage-cart-1.0.0-SNAPSHOT.jar --spring.cloud.bootstrap.enabled=true
java --add-opens=jdk.management/com.sun.management.internal=ALL-UNNAMED --add-opens=java.base/jdk.internal.misc=ALL-UNNAMED --add-opens=java.base/sun.nio.ch=ALL-UNNAMED --add-opens=java.management/com.sun.jmx.mbeanserver=ALL-UNNAMED --add-opens=jdk.internal.jvmstat/sun.jvmstat.monitor=ALL-UNNAMED --add-opens=java.base/sun.reflect.generics.reflectiveObjects=ALL-UNNAMED --add-opens=java.base/java.io=ALL-UNNAMED --add-opens=java.base/java.nio=ALL-UNNAMED --add-opens=java.base/java.util=ALL-UNNAMED --add-opens=java.base/java.lang=ALL-UNNAMED --add-opens=java.base/java.lang.reflect=ALL-UNNAMED --add-opens=java.base/java.lang.invoke=ALL-UNNAMED --add-opens=java.base/java.time=ALL-UNNAMED --add-opens=java.base/java.time.format=ALL-UNNAMED -jar ..\processing\target\microservice-flexpackage-processing-1.0.0-SNAPSHOT.jar --spring.cloud.bootstrap.enabled=true
```

##### CMD
```
set BROADLEAF_SECURE_ENV_DIR_PATH="[absolute path to the 'security' directory in your project]"
java --add-opens=jdk.management/com.sun.management.internal=ALL-UNNAMED --add-opens=java.base/jdk.internal.misc=ALL-UNNAMED --add-opens=java.base/sun.nio.ch=ALL-UNNAMED --add-opens=java.management/com.sun.jmx.mbeanserver=ALL-UNNAMED --add-opens=jdk.internal.jvmstat/sun.jvmstat.monitor=ALL-UNNAMED --add-opens=java.base/sun.reflect.generics.reflectiveObjects=ALL-UNNAMED --add-opens=java.base/java.io=ALL-UNNAMED --add-opens=java.base/java.nio=ALL-UNNAMED --add-opens=java.base/java.util=ALL-UNNAMED --add-opens=java.base/java.lang=ALL-UNNAMED --add-opens=java.base/java.lang.reflect=ALL-UNNAMED --add-opens=java.base/java.lang.invoke=ALL-UNNAMED --add-opens=java.base/java.time=ALL-UNNAMED --add-opens=java.base/java.time.format=ALL-UNNAMED -jar ..\auth\target\microservice-flexpackage-auth-1.0.0-SNAPSHOT.jar --spring.cloud.bootstrap.enabled=true
java --add-opens=jdk.management/com.sun.management.internal=ALL-UNNAMED --add-opens=java.base/jdk.internal.misc=ALL-UNNAMED --add-opens=java.base/sun.nio.ch=ALL-UNNAMED --add-opens=java.management/com.sun.jmx.mbeanserver=ALL-UNNAMED --add-opens=jdk.internal.jvmstat/sun.jvmstat.monitor=ALL-UNNAMED --add-opens=java.base/sun.reflect.generics.reflectiveObjects=ALL-UNNAMED --add-opens=java.base/java.io=ALL-UNNAMED --add-opens=java.base/java.nio=ALL-UNNAMED --add-opens=java.base/java.util=ALL-UNNAMED --add-opens=java.base/java.lang=ALL-UNNAMED --add-opens=java.base/java.lang.reflect=ALL-UNNAMED --add-opens=java.base/java.lang.invoke=ALL-UNNAMED --add-opens=java.base/java.time=ALL-UNNAMED --add-opens=java.base/java.time.format=ALL-UNNAMED -jar ..\supporting\target\microservice-flexpackage-supporting-1.0.0-SNAPSHOT.jar --spring.cloud.bootstrap.enabled=true
java --add-opens=jdk.management/com.sun.management.internal=ALL-UNNAMED --add-opens=java.base/jdk.internal.misc=ALL-UNNAMED --add-opens=java.base/sun.nio.ch=ALL-UNNAMED --add-opens=java.management/com.sun.jmx.mbeanserver=ALL-UNNAMED --add-opens=jdk.internal.jvmstat/sun.jvmstat.monitor=ALL-UNNAMED --add-opens=java.base/sun.reflect.generics.reflectiveObjects=ALL-UNNAMED --add-opens=java.base/java.io=ALL-UNNAMED --add-opens=java.base/java.nio=ALL-UNNAMED --add-opens=java.base/java.util=ALL-UNNAMED --add-opens=java.base/java.lang=ALL-UNNAMED --add-opens=java.base/java.lang.reflect=ALL-UNNAMED --add-opens=java.base/java.lang.invoke=ALL-UNNAMED --add-opens=java.base/java.time=ALL-UNNAMED --add-opens=java.base/java.time.format=ALL-UNNAMED -jar ..\browse\target\microservice-flexpackage-browse-1.0.0-SNAPSHOT.jar --spring.cloud.bootstrap.enabled=true
java --add-opens=jdk.management/com.sun.management.internal=ALL-UNNAMED --add-opens=java.base/jdk.internal.misc=ALL-UNNAMED --add-opens=java.base/sun.nio.ch=ALL-UNNAMED --add-opens=java.management/com.sun.jmx.mbeanserver=ALL-UNNAMED --add-opens=jdk.internal.jvmstat/sun.jvmstat.monitor=ALL-UNNAMED --add-opens=java.base/sun.reflect.generics.reflectiveObjects=ALL-UNNAMED --add-opens=java.base/java.io=ALL-UNNAMED --add-opens=java.base/java.nio=ALL-UNNAMED --add-opens=java.base/java.util=ALL-UNNAMED --add-opens=java.base/java.lang=ALL-UNNAMED --add-opens=java.base/java.lang.reflect=ALL-UNNAMED --add-opens=java.base/java.lang.invoke=ALL-UNNAMED --add-opens=java.base/java.time=ALL-UNNAMED --add-opens=java.base/java.time.format=ALL-UNNAMED -jar ..\cart\target\microservice-flexpackage-cart-1.0.0-SNAPSHOT.jar --spring.cloud.bootstrap.enabled=true
java --add-opens=jdk.management/com.sun.management.internal=ALL-UNNAMED --add-opens=java.base/jdk.internal.misc=ALL-UNNAMED --add-opens=java.base/sun.nio.ch=ALL-UNNAMED --add-opens=java.management/com.sun.jmx.mbeanserver=ALL-UNNAMED --add-opens=jdk.internal.jvmstat/sun.jvmstat.monitor=ALL-UNNAMED --add-opens=java.base/sun.reflect.generics.reflectiveObjects=ALL-UNNAMED --add-opens=java.base/java.io=ALL-UNNAMED --add-opens=java.base/java.nio=ALL-UNNAMED --add-opens=java.base/java.util=ALL-UNNAMED --add-opens=java.base/java.lang=ALL-UNNAMED --add-opens=java.base/java.lang.reflect=ALL-UNNAMED --add-opens=java.base/java.lang.invoke=ALL-UNNAMED --add-opens=java.base/java.time=ALL-UNNAMED --add-opens=java.base/java.time.format=ALL-UNNAMED -jar ..\processing\target\microservice-flexpackage-processing-1.0.0-SNAPSHOT.jar --spring.cloud.bootstrap.enabled=true
```

> NOTE: You will need to set the environment variable for every new shell you open to cover each of the java commands.

#### Quickstart: One/Mono Config (Windows)
If you've chosen the `One` Flex Package, run the following
maven commands (in separate terminal sessions) from the root of the `manifest` directory:

##### PowerShell
```
$env:BROADLEAF_SECURE_ENV_DIR_PATH="[absolute path to the 'security' directory in your project]"
java --add-opens=jdk.management/com.sun.management.internal=ALL-UNNAMED --add-opens=java.base/jdk.internal.misc=ALL-UNNAMED --add-opens=java.base/sun.nio.ch=ALL-UNNAMED --add-opens=java.management/com.sun.jmx.mbeanserver=ALL-UNNAMED --add-opens=jdk.internal.jvmstat/sun.jvmstat.monitor=ALL-UNNAMED --add-opens=java.base/sun.reflect.generics.reflectiveObjects=ALL-UNNAMED --add-opens=java.base/java.io=ALL-UNNAMED --add-opens=java.base/java.nio=ALL-UNNAMED --add-opens=java.base/java.util=ALL-UNNAMED --add-opens=java.base/java.lang=ALL-UNNAMED --add-opens=java.base/java.lang.reflect=ALL-UNNAMED --add-opens=java.base/java.lang.invoke=ALL-UNNAMED --add-opens=java.base/java.time=ALL-UNNAMED --add-opens=java.base/java.time.format=ALL-UNNAMED -jar ..\auth\target\microservice-flexpackage-auth-1.0.0-SNAPSHOT.jar --spring.cloud.bootstrap.enabled=true
java --add-opens=jdk.management/com.sun.management.internal=ALL-UNNAMED --add-opens=java.base/jdk.internal.misc=ALL-UNNAMED --add-opens=java.base/sun.nio.ch=ALL-UNNAMED --add-opens=java.management/com.sun.jmx.mbeanserver=ALL-UNNAMED --add-opens=jdk.internal.jvmstat/sun.jvmstat.monitor=ALL-UNNAMED --add-opens=java.base/sun.reflect.generics.reflectiveObjects=ALL-UNNAMED --add-opens=java.base/java.io=ALL-UNNAMED --add-opens=java.base/java.nio=ALL-UNNAMED --add-opens=java.base/java.util=ALL-UNNAMED --add-opens=java.base/java.lang=ALL-UNNAMED --add-opens=java.base/java.lang.reflect=ALL-UNNAMED --add-opens=java.base/java.lang.invoke=ALL-UNNAMED --add-opens=java.base/java.time=ALL-UNNAMED --add-opens=java.base/java.time.format=ALL-UNNAMED -jar ..\one\target\microservice-flexpackage-one-1.0.0-SNAPSHOT.jar --spring.cloud.bootstrap.enabled=true
```

##### CMD
```
set BROADLEAF_SECURE_ENV_DIR_PATH="[absolute path to the 'security' directory in your project]"
java --add-opens=jdk.management/com.sun.management.internal=ALL-UNNAMED --add-opens=java.base/jdk.internal.misc=ALL-UNNAMED --add-opens=java.base/sun.nio.ch=ALL-UNNAMED --add-opens=java.management/com.sun.jmx.mbeanserver=ALL-UNNAMED --add-opens=jdk.internal.jvmstat/sun.jvmstat.monitor=ALL-UNNAMED --add-opens=java.base/sun.reflect.generics.reflectiveObjects=ALL-UNNAMED --add-opens=java.base/java.io=ALL-UNNAMED --add-opens=java.base/java.nio=ALL-UNNAMED --add-opens=java.base/java.util=ALL-UNNAMED --add-opens=java.base/java.lang=ALL-UNNAMED --add-opens=java.base/java.lang.reflect=ALL-UNNAMED --add-opens=java.base/java.lang.invoke=ALL-UNNAMED --add-opens=java.base/java.time=ALL-UNNAMED --add-opens=java.base/java.time.format=ALL-UNNAMED -jar ..\auth\target\microservice-flexpackage-auth-1.0.0-SNAPSHOT.jar --spring.cloud.bootstrap.enabled=true
java --add-opens=jdk.management/com.sun.management.internal=ALL-UNNAMED --add-opens=java.base/jdk.internal.misc=ALL-UNNAMED --add-opens=java.base/sun.nio.ch=ALL-UNNAMED --add-opens=java.management/com.sun.jmx.mbeanserver=ALL-UNNAMED --add-opens=jdk.internal.jvmstat/sun.jvmstat.monitor=ALL-UNNAMED --add-opens=java.base/sun.reflect.generics.reflectiveObjects=ALL-UNNAMED --add-opens=java.base/java.io=ALL-UNNAMED --add-opens=java.base/java.nio=ALL-UNNAMED --add-opens=java.base/java.util=ALL-UNNAMED --add-opens=java.base/java.lang=ALL-UNNAMED --add-opens=java.base/java.lang.reflect=ALL-UNNAMED --add-opens=java.base/java.lang.invoke=ALL-UNNAMED --add-opens=java.base/java.time=ALL-UNNAMED --add-opens=java.base/java.time.format=ALL-UNNAMED -jar ..\one\target\microservice-flexpackage-one-1.0.0-SNAPSHOT.jar --spring.cloud.bootstrap.enabled=true
```

> NOTE: You will need to set the environment variable for every new shell you open to cover each of the java commands.

#### Alternative Launch Process via Docker
The steps mentioned above to launch a module are generally more convenient when working with
a `Balanced` and `Mono` configuration. For a `Granular` Flex Package configuration, you may
want to containerize all Flex Packages and run everything through `Docker Compose`.
To do this, you can build the services with the following maven profile: `docker` e.g.
Running `./mvnw clean install -Pdocker -f ../` from the manifest directory will build each service
and also produce a local docker image. From there, you can modify the `docker.components` element
in your `manifest.yml` file to include all containerized Flex Packages, run
`./mvnw docker-compose:generate` again to generate a docker compose file with all services and
finally run `./mvnw docker-compose:up` to start the entire ecosystem. Note, doing this does
require a hefty amount of machine resources as it effectively has to manage over 30 individual containers.

### Done!
That’s it! Once you’ve verified that the supporting services and backend APIs are running,
you can visit the administration console and the consumer storefronts (if enabled) from a browser:

> TIP: If you enabled the demo storefront, you may need to enable insecure localhost by visiting:
`chrome://flags/#allow-insecure-localhost`

- Admin Console: https://localhost:8446
  * Username: `master@test.com`
  * Password: `<dynamically generated>`

> NOTE: the default passwords for the initial admin master users are dynamically generated and
  can be found in your `security` folder in your `credentials-report.env` file.

- If you enabled the "Open API" on your `manifest.yml`
  * Open API UI: https://localhost:8446/api/docs

- If you enabled the "Hot Sauce Demo" on your `manifest.yml`:
  * Storefront 1: https://heatclinic.localhost:8456
  * Storefront 2: https://aaahotsauces.localhost:8456

> NOTE: If you're not seeing demo data on any of the product listing pages or search result pages,
  then you may need to go into the Admin, navigate to the `Search` section, click on `Reindex`
  and proceed to `Create Job` of type `Product` to start the indexing process.
  Once complete, you can re-visit the storefronts and products should now be visible.

## Broadleaf Microservice Fundamentals

### Security
Security in a system is an important consideration and Broadleaf is no exception.
There are varying degrees in which you can choose to apply security and it can depend on
several factors including:

- Internal Corporate Policies
- Industry or Regulatory Requirements
- Environments that you are trying to deploy to

Broadleaf generates an initial starting point that creates sensible and
secure defaults allowing you the implementor to easily dial up the security needs if needed or
make a conscious choice to dial down certain security measures when it seems appropriate for
your needs.

Running the `flex:generate` process will create a `security` folder that contains important
security related files and information needed for your installation that will holistically
tie the system together. Note that the contents of these generated files are cryptographically
unique upon generation.

IMPORTANT: **the contents of the `security` directory should NOT be stored in source control**, but
instead should be uploaded and managed in a secure location such as an encrypted vault.

More details around the contents of this `security` folder can be found on
Broadleaf's [Developer Portal](https://developer.broadleafcommerce.com/production/initializr-security)

### Config Server

Broadleaf recommends enabling the Spring Cloud Config Server as part of your project.
Broadleaf provides an implementation of [Spring Cloud Config](https://docs.spring.io/spring-cloud-config/docs/current/reference/html/)
that supports maintaining and managing externalized application configuration well-suited
for a distributed microservices architecture. Broadleaf provides a **production-ready** Docker image
that can be used in your implementation for this purpose.

To enable `Config Server` in your project, verify that the `config` supporting component is enabled
in your `manifest.yml` file as shown below:

```
supporting:
- name: config
  platform: config
  descriptor: snippets/docker-config.yml
  enabled: false <------ set this to true
  domain:
    cloud: config
    docker: config
    local: localhost
  ports:
    port: '8888'
```

After running a `flex:generate` command with the `config` component enabled, you will notice
a few things

- Your project should contain a new `config` directory containing both a `secure` and `insecure`
folder. These folders are intended to hold and store their respective types of properties. It is important
to read the `README` contained in the config directory as **you should not immediately check
these folders into source control**. It is best practice to limit the scope
of who can manage and view some of these properties (the README details various best practice
approaches).

- You should also notice that the properties in the `secure` directory are encrypted. These
secure properties were generated and encrypted as part of the `security flex:generate` process.

- After running `docker-compose:generate`, you will notice that your generated `target/docker/docker-compose.yml`
will contain an entry for the `config` resource that uses Broadleaf's production docker image:
`image: repository.broadleafcommerce.com:5001/broadleaf/broadleaf-config-server-platform:X.X.X-GA`
This `docker-compose` configuration is set up in such a way to load the configurations
(both secure and insecure directories) on your local filesystem. The system will detect
and mount both of these folders appropriately to run the project on a local machine.

More details around the capabilities of this config service can be found on
Broadleaf's [Developer Portal](https://developer.broadleafcommerce.com/shared-concepts/enhanced-env-config)

### Extending Core Commerce API Components

To extend Broadleaf's microservice components or supporting services, you can set
certain properties on your `manifest.yml` allowing you to generate the appropriate
project structure and folders needed for that extension whenever you run `flex:generate`.

For example, if you would like to extend a core commerce `component` such as `CATALOG`,
find the `catalog` component in your `manifest.yml` file and set the `enabled` property to `true`.

```
components:
  - name: catalog
    routed: true
    domain:
      local: localhost
      docker: catalog
      cloud: catalog
    enabled: false <------ set this to true
    ports:
      - port: 8442
        targetPort: 8442
      - port: 8999
        targetPort: 8999
        debug: true
```

> With the component "enabled", a new project folder called `catalogComponent` will be generated
the next time you run `flex:generate`

### Generating Sample Code
If you would like to include sample code (autoconfiguration, sample domain, and test) for an
enabled service library component during project structure generation, set the `sampleCode` property
to `true`.

```
components:
  - name: catalog
    routed: true
    domain:
      local: localhost
      docker: catalog
      cloud: catalog
    sampleCode: false <------ set this to true
    ports:
      - port: 8442
        targetPort: 8442
      - port: 8999
        targetPort: 8999
        debug: true
```

### Downloading Other Accelerator Components
If you would like to edit the source of other supporting components in the
full ecosystem like the Gateways, Solr Instance, the React Admin, or the Next.js Storefront code,
you can set the `editSource` property to `true` in your `manifest.yml`.

For example, if you want to download and see the source code for the Storefront application,
find the `commerceweb` "other" component definition and set the `editSource` property to `true`.

```
others:
  - name: commerceweb
    routed: true
    domain:
      local: localhost
      docker: commerceweb
      cloud: commerceweb
    enabled: true
    editSource: false <------ set this to true
    ports:
      - port: 4000
        targetPort: 4000
```

> With the `commerceweb` "editSource" set to `true`, a new assembly zip file will be downloaded
with the source code for the storefront the next time you run `flex:generate`

## Evolving Your Project Structure
As your implementation progresses and the understanding of your overall project needs evolve,
you may find yourself needing to tweak and modify the `manifest.yml` file directly after
you've already generated the initial project structure. Further modification of the `manifest.yml`
directly is supported and encouraged. Once you've modified the manifest
to change project structure, you can run `flex:generate` again and the plugin will
create the appropriate project changes to support the updated configuration.

> NOTE: Changes made during subsequent `flex:generate` calls are cautious.
The plugin won’t delete code or directories. Furthermore, it will create a backup of the current
pom file before editing it for the `flex:generate` run. Any `pom.xml` file edits will not remove
custom elements that may have been added before (including any custom dependencies).

## Core Broadleaf Framework Concepts
Below you will find links to core framework concepts that are important to be familiar with.
Using these core concepts, you can support a variety of different business models, use cases,
and industry verticals.

### Tenants, Applications, and Catalogs
* [Tenants and Applications](https://developer.broadleafcommerce.com/shared-concepts/multi-tenancy#tenants_and_applications)
* [Business Models Supported by Core Concepts](https://developer.broadleafcommerce.com/shared-concepts/multi-tenancy#considerations)
* [Tenant and Application Resolution](https://developer.broadleafcommerce.com/tutorials/frontend-walkthroughs/tenant-resolution)
* [Catalogs](https://developer.broadleafcommerce.com/shared-concepts/multi-tenancy#catalogs)
* [Catalogs and Applications](https://developer.broadleafcommerce.com/services/tenant-services)

### Sandboxing
* [Data Workflow](https://developer.broadleafcommerce.com/shared-concepts/data-workflow)
* [Sandboxes](https://developer.broadleafcommerce.com/services/sandbox-services)
    
## What's Next?
Now that you have your Broadleaf projects generated, checkout out these links to experience
how to work with and extend Broadleaf to suit your implementation needs:

* [Initializr Docs](https://developer.broadleafcommerce.com/initializr)
* [IntelliJ Setup](https://developer.broadleafcommerce.com/starter-projects/intellij-setup)
* [Extension Concepts Example Project](https://github.com/BroadleafCommerce/MicroservicesConcepts)
* [Customizing Broadleaf](https://developer.broadleafcommerce.com/tutorials/customize-broadleaf)
* [Training Videos](https://broadleaf-commerce.mylearnworlds.com/)

## Advanced Topics

### Manifest YAML Anatomy
Here are some brief descriptions around the different components that are represented
in a typical manifest file:

```
manifest.yml
└── flexPackages (1)
│   └── supporting (2)
│   └── browse
│   └── ...
└── components (3)
│   └── adminnav
│   └── adminuser
│   └── ...
└── supporting (4)
│   └── database
│   └── broker
│   └── ...
└── others (5)
│   └── adminweb
│   └── commerceweb
│   └── ...
└── docker (6)
```

1. Flex Package definitions are responsible for exposing all relevant "library"
component artifacts into a single application runtime. See the property: `flexUnits` to understand
which libraries are "bundled" into a defined flex package.
2. A single flex package definition can be `enabled` (see `enabled` property) based on a defined composition.
For example, if the `Balanced` composition is chosen, the following flex packages will be enabled: `supporting`,
`browse`, `cart`, `processing`, and `auth`.
3. These definitions represent properties needed for a specific "library" component.
These types of components are related to microservice source code. This is different from a
"flex package component" whose main purpose is to simply expose the application runtime and Docker image
for the microservice. Library Components are where code and extensions are introduced to modify
the behavior of that microservice.
4. Describes a supporting concept in the form of a Docker image. These items are generally not
customized at the code level, but their behavior may be customized by environment variable. This
covers things like database and message brokers, but also includes more microservice
specific concepts like gateways and config servers.
5. The "other" component definition is neither a Flex Package nor standard java microservice library
component. This type of component relates to frontend projects, such as: React Admin Starter,
NextJS Commerce Starter, and an Open API starter.
6. The docker definitions describe attributes specific to the generation of `docker-compose.yml`
when executing the `docker-compose:generate` command. Also cover general Docker image related information

> TIP: The manifest.yml file adheres to a schema object model. The Javadocs for the schema (with descriptions) are available at: https://javadocs.ci.broadleafcommerce.com/broadleaf-microservices-starter-manifest-schema/1.1.3-GA

### Starter Parent Properties
Here are a list of interesting `maven` properties that you may want to configure
on your Flex Component projects `pom.xml`. These properties can drive additional maven behavior
defined in the inherited Starter Parent.

* `<skip-schema>` : Disables automatic liquibase schema generation
* `<skip-mapper-cache>` : Disables the generation of serialized ModelMapper artifacts. See [Developer Portal](https://developer.broadleafcommerce.com/production/configuration/caching#modelmapper_cache_overview) for more details
* `<skip-key-tool>` : Disables the invocation of the `keytool-maven-plugin` which will generate a `local.keystore` file for each project
* `<skip-docker-image>` : Disables the `docker` maven profile. If disabled, the build process will not produce a docker image when the `-Pdocker` profile is passed in.
* `<skip-flex-changelog>` : Disables the dynamic nature of the `changelog-generation-maven-plugin` where a "dynamic connection" to the manifest is maintained during a typical `mvn install` process.
* `<image-deployment-repo-domain>` : Works in conjunction with the `-Pdocker` maven profile to produce a local docker image. Defaults to `repository.broadleafcommerce.com`
* `<image-deployment-repo-port>` : Works in conjunction with the `-Pdocker` maven profile to produce a local docker image. Defaults to `5001`
* `<image-tag-prefix>` : Works in conjunction with the `-Pdocker` maven profile to produce a local docker image. Defaults to `broadleaf-demo`

## Broadleaf Service Documentation
* [Admin Navigation Services Documentation](https://developer.broadleafcommerce.com/services/admin-navigation-services)
* [Admin User Services Documentation](https://developer.broadleafcommerce.com/services/admin-user-services)
* [Asset Services Documentation](https://developer.broadleafcommerce.com/services/asset-services)
* [Bulk Operations Services Documentation](https://developer.broadleafcommerce.com/services/bulk-operations-services)
* [Cart Services Documentation](https://developer.broadleafcommerce.com/services/cart-services)
* [CartOps Services Documentation](https://developer.broadleafcommerce.com/services/cart-operation-services)
* [Catalog Services Documentation](https://developer.broadleafcommerce.com/services/catalog-services)
* [Catalog Browse Services Documentation](https://developer.broadleafcommerce.com/services/catalog-browse-services)
* [Content Services Documentation](https://developer.broadleafcommerce.com/services/content-services)
* [Credit Account Services Documentation](https://developer.broadleafcommerce.com/services/credit-account-services)
* [Customer Services Documentation](https://developer.broadleafcommerce.com/services/customer-services)
* [Fulfillment Services Documentation](https://developer.broadleafcommerce.com/services/fulfillment-services)
* [Import Services Documentation](https://developer.broadleafcommerce.com/services/import-services)
* [Indexer Services Documentation](https://developer.broadleafcommerce.com/services/search-services)
* [Inventory Services Documentation](https://developer.broadleafcommerce.com/services/inventory-services)
* [Menu Services Documentation](https://developer.broadleafcommerce.com/services/menu-services)
* [Metadata Services Documentation](https://developer.broadleafcommerce.com/services/metadata-services)
* [Notification Services Documentation](https://developer.broadleafcommerce.com/services/notification-services)
* [Offer Services Documentation](https://developer.broadleafcommerce.com/services/offer-services)
* [Order Services Documentation](https://developer.broadleafcommerce.com/services/order-services)
* [OrderOps Services Documentation](https://developer.broadleafcommerce.com/services/order-operation-services)
* [Payment Transaction Services Documentation](https://developer.broadleafcommerce.com/services/payment-transaction-services)
* [Pricing Services Documentation](https://developer.broadleafcommerce.com/services/pricing-services)
* [Rating and Review Services Documentation](https://developer.broadleafcommerce.com/services/rating-and-review-services)
* [Sandbox Services Documentation](https://developer.broadleafcommerce.com/services/sandbox-services)
* [Scheduled Job Services Documentation](https://developer.broadleafcommerce.com/services/scheduled-job-services)
* [Search Services Documentation](https://developer.broadleafcommerce.com/services/search-services)
* [Shipping Services Documentation](https://developer.broadleafcommerce.com/services/shipping-services)
* [Tenant Services Documentation](https://developer.broadleafcommerce.com/services/tenant-services)
* [Vendor Services Documentation](https://developer.broadleafcommerce.com/services/vendor-services)

