<img alt="Drupal Logo" src="https://www.drupal.org/files/Wordmark_blue_RGB.png" height="60px">

Drupal is an open source content management platform supporting a variety of
websites ranging from personal weblogs to large community-driven websites. For
more information, visit the Drupal website, [Drupal.org][Drupal.org], and join
the [Drupal community][Drupal community].

## Contributing

Drupal is developed on [Drupal.org][Drupal.org], the home of the international
Drupal community since 2001!

[Drupal.org][Drupal.org] hosts Drupal's [GitLab repository][GitLab repository],
its [issue queue][issue queue], and its [documentation][documentation]. Before
you start working on code, be sure to search the [issue queue][issue queue] and
create an issue if your aren't able to find an existing issue.

Every issue on Drupal.org automatically creates a new community-accessible fork
that you can contribute to. Learn more about the code contribution process on
the [Issue forks & merge requests page][issue forks].

## Security

For a list of security announcements, see the [Security advisories
page][Security advisories] (available as [an RSS feed][security RSS]). This
page also describes how to subscribe to these announcements via email.

For information about the Drupal security process, or to find out how to report
a potential security issue to the Drupal security team, see the [Security team
page][security team].

## Need a helping hand?

Visit the [Support page][support] or browse [over a thousand Drupal
providers][service providers] offering design, strategy, development, and
hosting services.

## How to Setup using docker
1. This Repo is docker based container's setup
2. Download the docker desktop based on the operating system (https://www.docker.com/products/docker-desktop/)
3. Clone the Leeds jobs Repo and checkout to "main" branch
4. For this docker setup we need to have 2 containers
    4.a. Application container
    4.b. Mysql Container

[4.a.] Application container - For application container with the docker file need to run "docker build -t image-name:latest . "

The above command spin up an docker image 
and next run the docker image with the required port specified "docker run -p 8080:80 image-name:latest"

[4.b.]Mysql Container - For mysql container use the below command
"docker run -d -p 3306:3306 --name mysql-docker-container -e MYSQL_ROOT_PASSWORD=database_password -e MYSQL_DATABASE=database_name -e MYSQL_USER=database_username -e MYSQL_PASSWORD=database_password mysql/mysql-server:latest"

5. With the following commands both docker containers are available and now setup the database settings in the settings.php file to connect to the databse with the application
    Example: 
        $databases['default']['default'] = [
        'database' => 'database_name',
        'username' => 'database_username',
        'password' => 'database_password',
        'prefix' => '',
        'host' => '172.17.0.2',
        'port' => '3306',
        'namespace' => 'Drupal\Core\Database\Driver\mysql',
        'driver' => 'mysql',
        ];
6. "host" name is the mysql-docker-container-name ip address and to check that need to inspect the conatiner ( docker inspect mysql-docker-container-name)
7. if you have the db already import it with the command "docker exec -i mysql-docker-container mysql -u database_username -p database_password database_name < filename.mysql"
8. Now access the site using the http://localhost:8080
9. if you want to connect to your mysql-client you can use the command "docker exec -it mysql-conatiner-name bash"
10. if you want to push the docker image to the docker hub, will need to create an account in docker hub and also the repository
11. docker login -u "username" -p "password" docker.io
should create a docker tag for the existing docker image with the command "docker tag docker-image-name username/repo-name:tag-version
docker push usernmame:tag-version
12. if you want to pull the existing image with the command "docker pull username/repo-name:tag-version"