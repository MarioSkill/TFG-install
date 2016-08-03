-- phpMyAdmin SQL Dump
-- version 4.6.3
-- https://www.phpmyadmin.net/
--
-- Servidor: localhost
-- Tiempo de generación: 03-08-2016 a las 10:31:05
-- Versión del servidor: 5.6.28
-- Versión de PHP: 5.6.18

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `tfg2`
--
CREATE DATABASE IF NOT EXISTS `tfg-test` DEFAULT CHARACTER SET utf8 COLLATE utf8_spanish_ci;
USE `tfg-test`;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Algoritmos`
--

CREATE TABLE `Algoritmos` (
  `id` int(10) NOT NULL,
  `Nombre` varchar(100) COLLATE utf8_spanish_ci NOT NULL,
  `Descripcion` varchar(400) COLLATE utf8_spanish_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `Algoritmos`
--

INSERT INTO `Algoritmos` (`id`, `Nombre`, `Descripcion`) VALUES
(1, 'WC', 'Contar Palabras'),
(2, 'K-MEANS', 'Partición de un conjunto de n observaciones en k grupos'),
(3, 'GREP', 'Busca la aparición de una palabra en un texto'),
(4, 'SHORT', 'Ordenación de numeros');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Comparativa`
--

CREATE TABLE `Comparativa` (
  `id` int(10) NOT NULL,
  `test` int(10) NOT NULL,
  `fecha` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Configuracion`
--

CREATE TABLE `Configuracion` (
  `id` int(10) NOT NULL,
  `OP` varchar(100) COLLATE utf8_spanish_ci NOT NULL,
  `FicheroSalida` varchar(300) COLLATE utf8_spanish_ci NOT NULL,
  `Logs` varchar(300) COLLATE utf8_spanish_ci NOT NULL,
  `paramEjucucion` varchar(5000) COLLATE utf8_spanish_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Estado`
--

CREATE TABLE `Estado` (
  `id` int(10) NOT NULL,
  `nombre` varchar(30) COLLATE utf8_spanish_ci NOT NULL,
  `descripcion` text COLLATE utf8_spanish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `Estado`
--

INSERT INTO `Estado` (`id`, `nombre`, `descripcion`) VALUES
(1, 'Activo', 'La prueba no ha terminado y se esta ejecutando el algoritmo en su contenedor.'),
(2, 'Terminado', 'La prueba ha terminado de forma satisfactoria'),
(3, 'Cancelado', 'El usuario ha decidido interrumpir la prueba.'),
(4, 'Perdido', 'La prueba se lanzo pero se ha perdido el contenedor.'),
(5, 'Programado', 'La prueba esta en cola para ser lanzada.'),
(6, 'Error', 'La prueba ha terminado con errores.');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Ficheros`
--

CREATE TABLE `Ficheros` (
  `id` int(10) NOT NULL,
  `nombre` varchar(64) COLLATE utf8_spanish_ci NOT NULL,
  `ruta` varchar(125) COLLATE utf8_spanish_ci NOT NULL,
  `size` varchar(100) COLLATE utf8_spanish_ci NOT NULL,
  `ext` varchar(4) COLLATE utf8_spanish_ci DEFAULT NULL,
  `fecha` datetime NOT NULL,
  `rutaDataDocker` varchar(250) COLLATE utf8_spanish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Programas`
--

CREATE TABLE `Programas` (
  `id` int(10) NOT NULL,
  `Nombre` varchar(30) COLLATE utf8_spanish_ci NOT NULL,
  `Version` varchar(10) COLLATE utf8_spanish_ci DEFAULT NULL,
  `Dockerfile` text COLLATE utf8_spanish_ci,
  `Bin` varchar(300) COLLATE utf8_spanish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `Programas`
--

INSERT INTO `Programas` (`id`, `Nombre`, `Version`, `Dockerfile`, `Bin`) VALUES
(1, 'SPARK', '1.6.1', '#############################################################\r\n# Archivo Dockerfile para ejecutar apache Spark\r\n# Basado en una imagen de Ubuntu\r\n#############################################################\r\n\r\n# Establece la imagen de base a utilizar para Ubuntu\r\nFROM ubuntu:14.04\r\n\r\n# Establece el autor (maintainer) del archivo (tu nombre - el autor del archivo)\r\nMAINTAINER Mario <100292688@alumnos.uc3m.es>\r\n\r\n# Actualización de la lista de fuentes del repositorio de aplicaciones por defecto\r\nRUN apt-get update && \\\r\n    apt-get upgrade -y && \\\r\n    apt-get install -y  software-properties-common && \\\r\n    add-apt-repository ppa:webupd8team/java -y && \\\r\n    apt-get update && \\\r\n    echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \\\r\n    apt-get install -y oracle-java8-installer && \\\r\n    apt-get install -y git && \\\r\n    apt-get clean\r\n\r\n#MAINTAINER Sven Dowideit <SvenDowideit@docker.com>  https://docs.docker.com/engine/examples/running_ssh_service/ ssh docker\r\n\r\nRUN apt-get install -y openssh-server\r\n\r\nRUN mkdir /var/run/sshd\r\nRUN echo \'root:spark\' | chpasswd\r\nRUN sed -i \'s/PermitRootLogin without-password/PermitRootLogin yes/\' /etc/ssh/sshd_config\r\n\r\n# SSH login fix. Otherwise user is kicked off after login\r\nRUN sed \'s@session\\s*required\\s*pam_loginuid.so@session optional pam_loginuid.so@g\' -i /etc/pam.d/sshd\r\n\r\nENV NOTVISIBLE "in users profile"\r\nRUN echo "export VISIBLE=now" >> /etc/profile\r\n\r\nEXPOSE 22\r\nCMD ["/usr/sbin/sshd", "-D"]\r\n\r\nENV JAVA_HOME /usr/lib/jvm/java-8-oracle/\r\nRUN wget http://www.scala-lang.org/files/archive/scala-2.10.4.tgz\r\nRUN mkdir /usr/local/src/scala\r\nRUN tar xvf scala-2.10.4.tgz -C /usr/local/src/scala/\r\nENV SCALA_HOME /usr/local/src/scala/scala-2.10.4\r\nRUN echo "export PATH=$SCALA_HOME/bin:$PATH"\r\nRUN wget http://apache.rediris.es/spark/spark-1.6.0/spark-1.6.0.tgz\r\nRUN mkdir /usr/local/src/spark\r\nRUN tar xvf spark-1.6.0.tgz -C /usr/local/src/spark/\r\nENV SPARK_HOME /usr/local/src/spark/spark-1.6.0\r\nRUN echo "export PATH=$SPARK_HOME/bin:$PATH"\r\nRUN ln -s /usr/local/src/spark/spark-1.6.0/project/ /project\r\nRUN ln -s /usr/local/src/spark/spark-1.6.0/build/ /\r\nRUN /usr/local/src/spark/spark-1.6.0/make-distribution.sh\r\nRUN rm scala-2.10.4.tgz\r\nRUN rm spark-1.6.0.tgz', '/usr/local/src/spark/spark-1.6.1/bin/spark-submit'),
(2, 'FLINK', '0.10.2', '		#############################################################\r\n				# Archivo Dockerfile para ejecutar apache FLINK             #\r\n				# Basado en una imagen de Ubuntu                            #\r\n				#############################################################\r\n\r\n# Establece la imagen de base a utilizar para Ubuntu\r\nFROM ubuntu:14.04\r\n\r\n# Establece el autor (maintainer) del archivo (tu nombre - el autor del archivo)\r\nMAINTAINER Mario <100292688@alumnos.uc3m.es>\r\n\r\n# Actualización de la lista de fuentes del repositorio de aplicaciones por defecto\r\nRUN apt-get update && \\\r\n    apt-get upgrade -y && \\\r\n    apt-get install -y  software-properties-common && \\\r\n    add-apt-repository ppa:webupd8team/java -y && \\\r\n    apt-get update && \\\r\n    echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \\\r\n    apt-get install -y oracle-java8-installer && \\\r\n    apt-get install -y git && \\\r\n    apt-get clean\r\n\r\n#MAINTAINER Sven Dowideit <SvenDowideit@docker.com>  https://docs.docker.com/engine/examples/running_ssh_service/ ssh docker\r\n\r\n#RUN apt-get install -y openssh-server\r\n\r\n#RUN mkdir /var/run/sshd\r\n#RUN echo \'root:flink\' | chpasswd\r\n#RUN sed -i \'s/PermitRootLogin without-password/PermitRootLogin yes/\' /etc/ssh/sshd_config\r\n\r\n# SSH login fix. Otherwise user is kicked off after login\r\n#RUN sed \'s@session\\s*required\\s*pam_loginuid.so@session optional pam_loginuid.so@g\' -i /etc/pam.d/sshd\r\n\r\n#ENV NOTVISIBLE "in users profile"\r\n#RUN echo "export VISIBLE=now" >> /etc/profile\r\n\r\n#EXPOSE 22\r\n#CMD ["/usr/sbin/sshd", "-D"]\r\nEXPOSE 8081:8081\r\n\r\nENV JAVA_HOME /usr/lib/jvm/java-8-oracle/\r\nRUN wget http://www.scala-lang.org/files/archive/scala-2.10.4.tgz\r\nRUN mkdir /usr/local/src/scala\r\nRUN tar xvf scala-2.10.4.tgz -C /usr/local/src/scala/\r\nENV SCALA_HOME /usr/local/src/scala/scala-2.10.4\r\n#RUN echo "export PATH=$SCALA_HOME/bin:$PATH"\r\nRUN wget http://apache.rediris.es/flink/flink-0.10.2/flink-0.10.2-bin-hadoop1.tgz\r\nRUN mkdir /usr/local/src/flink\r\nRUN tar xvf flink-0.10.2-bin-hadoop1.tgz -C /usr/local/src/flink/\r\nENV FLINK_HOME /usr/local/src/flink/flink-0.10.2\r\n#RUN echo "export PATH=$FLINK_HOME/bin:$PATH"\r\nRUN ln -sf /usr/local/src/flink/flink-0.10.2/bin/ ./flink\r\n\r\nRUN rm scala-2.10.4.tgz\r\nRUN rm flink-0.10.2-bin-hadoop1.tgz\r\n\r\n\r\nADD init-flink.sh /init-flink.sh\r\nRUN chmod -v +x /init-flink.sh\r\nCMD ["/init-flink.sh"]', '/usr/local/src/flink/flink-0.10.2/bin/flink run'),
(3, 'STORM', '1.60', '#############################################################\r\n# Archivo Dockerfile para ejecutar apache STORM\r\n# Basado en una imagen de Ubuntu\r\n#############################################################\r\n\r\n# Establece la imagen de base a utilizar para Ubuntu\r\nFROM ubuntu:14.04\r\n\r\n# Establece el autor (maintainer) del archivo (tu nombre - el autor del archivo)\r\nMAINTAINER Mario <100292688@alumnos.uc3m.es>\r\n# BASADO EN Florian HUSSONNOIS, florian.hussonnois_gmail.com https://hub.docker.com/r/fhuz/docker-storm/~/dockerfile/\r\n\r\n# Actualización de la lista de fuentes del repositorio de aplicaciones por defecto\r\nRUN apt-get update && \\\r\n    apt-get upgrade -y && \\\r\n    apt-get install -y  software-properties-common && \\\r\n    add-apt-repository ppa:webupd8team/java -y && \\\r\n    apt-get update && \\\r\n    echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \\\r\n    apt-get install -y oracle-java8-installer && \\\r\n    apt-get install -y git && \\\r\n    apt-get install -y maven && \\\r\n    apt-get install -y curl && \\\r\n    apt-get clean\r\n\r\n# Tells Supervisor to run interactively rather than daemonize\r\nRUN apt-get install -y supervisor wget tar \r\nRUN echo [supervisord] | tee -a /etc/supervisor/supervisord.conf ; echo nodaemon=true | tee -a /etc/supervisor/supervisord.conf\r\n\r\nENV STORM_VERSION 0.10.0\r\nENV JAVA_HOME /usr/lib/jvm/java-8-oracle/\r\n# Create storm group and user\r\nENV STORM_HOME /usr/local/src/apache-storm\r\n\r\nRUN groupadd storm; useradd --gid storm --home-dir /home/storm --create-home --shell /bin/bash storm\r\n\r\n# Download and Install Apache Storm\r\nRUN wget http://apache.mirrors.ovh.net/ftp.apache.org/dist/storm/apache-storm-$STORM_VERSION/apache-storm-$STORM_VERSION.tar.gz && \\\r\ntar -xzvf apache-storm-$STORM_VERSION.tar.gz -C /usr/local/src/ && mv $STORM_HOME-$STORM_VERSION $STORM_HOME && \\\r\nrm -rf apache-storm-$STORM_VERSION.tar.gz\r\n\r\nRUN mkdir /var/log/storm ; chown -R storm:storm /var/log/storm ; ln -s /var/log/storm /home/storm/log\r\nRUN ln -s $STORM_HOME/bin/storm /usr/bin/storm\r\nRUN cd /usr/local/src/apache-storm/examples/storm-starter && mvn clean install -DskipTests=true\r\n#RUN cd /usr/local/src/apache-storm/examples/storm-starter && mvn compile exec:java -Dstorm.topology=storm.starter.WordCountTopology\r\n#ADD conf/storm.yaml.template $STORM_HOME/conf/storm.yaml.template\r\n\r\n# Add scripts required to run storm daemons under supervision\r\n#ADD script/entrypoint.sh /home/storm/entrypoint.sh\r\n#ADD supervisor/storm-daemon.conf /home/storm/storm-daemon.conf\r\n\r\n#RUN chown -R storm:storm $STORM_HOME && chmod u+x /home/storm/entrypoint.sh', '/usr/local/src/apache-storm-$STORM_VERSION/bin/storm jar'),
(4, 'TODOS', '1', 'null', 'null');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Resultado`
--

CREATE TABLE `Resultado` (
  `id` int(10) NOT NULL,
  `tiempo` varchar(3000) COLLATE utf8_spanish_ci DEFAULT NULL,
  `cpu` text COLLATE utf8_spanish_ci,
  `ModeloCPU` varchar(300) COLLATE utf8_spanish_ci DEFAULT NULL,
  `NucleosCPU` varchar(100) COLLATE utf8_spanish_ci DEFAULT NULL,
  `ram` text COLLATE utf8_spanish_ci,
  `TotalRAM` varchar(100) COLLATE utf8_spanish_ci DEFAULT NULL,
  `log` text COLLATE utf8_spanish_ci,
  `test` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Rol`
--

CREATE TABLE `Rol` (
  `id` int(10) NOT NULL,
  `name` varchar(60) COLLATE utf8_spanish_ci NOT NULL,
  `role` varchar(20) COLLATE utf8_spanish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `Rol`
--

INSERT INTO `Rol` (`id`, `name`, `role`) VALUES
(1, 'Administrador', 'ROLE_ADMIN');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ScriptBenchmark`
--

CREATE TABLE `ScriptBenchmark` (
  `id` int(10) NOT NULL,
  `contenido` varchar(1024) COLLATE utf8_spanish_ci NOT NULL,
  `ruta` varchar(300) COLLATE utf8_spanish_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Scripts`
--

CREATE TABLE `Scripts` (
  `id` int(10) NOT NULL,
  `Nombre` varchar(100) COLLATE utf8_spanish_ci NOT NULL,
  `bin` varchar(300) COLLATE utf8_spanish_ci NOT NULL,
  `class` varchar(2000) COLLATE utf8_spanish_ci DEFAULT NULL,
  `Algoritmo` int(10) NOT NULL,
  `Programa` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `Scripts`
--

INSERT INTO `Scripts` (`id`, `Nombre`, `bin`, `class`, `Algoritmo`, `Programa`) VALUES
(1, 'SparkWordCount', '/bigData/script/spark/spark-examples_2.10-1.6.1.jar', '--class org.apache.spark.examples.JavaWordCount ', 1, 1),
(2, 'FlinkWordCount', '/bigData/script/flink/mvn/master/flink-examples/flink-examples-batch/target/flink-examples-batch_2.10-1.1-SNAPSHOT-WordCount.jar', NULL, 1, 2),
(3, 'StormWordCount', '/bigData/script/storm/storm-starter-1.0.1/target/storm-starter-1.0.1.jar org.apache.storm.starter.WordCountTopology WordCount -c org.apache.storm.starter.WordCountTopology WordCount -c nimbus.host=localhost', NULL, 1, 3),
(4, 'SparkKmeans', '/bigData/script/spark/SparkKmeans.py', NULL, 2, 1),
(5, 'SparkGrep', '/bigData/script/spark/SparkGrep.scala localhost', NULL, 3, 1),
(6, 'SparkSort', '/bigData/script/spark/SparkSort.py', NULL, 4, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Test`
--

CREATE TABLE `Test` (
  `id` int(10) NOT NULL,
  `comand` varchar(1024) COLLATE utf8_spanish_ci NOT NULL,
  `container_id` varchar(64) COLLATE utf8_spanish_ci DEFAULT NULL,
  `container_name` varchar(128) COLLATE utf8_spanish_ci NOT NULL,
  `inicio` datetime DEFAULT NULL,
  `fin` datetime DEFAULT NULL,
  `Fichero` int(10) NOT NULL,
  `Programa` int(10) NOT NULL,
  `Algoritmo` int(10) NOT NULL,
  `Estado` int(10) NOT NULL,
  `ScriptBenchmark` int(10) NOT NULL,
  `Configuracion` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `User`
--

CREATE TABLE `User` (
  `id` int(10) NOT NULL,
  `username` varchar(64) COLLATE utf8_spanish_ci NOT NULL,
  `salt` varchar(64) COLLATE utf8_spanish_ci NOT NULL,
  `password` varchar(88) COLLATE utf8_spanish_ci NOT NULL,
  `email` varchar(64) COLLATE utf8_spanish_ci NOT NULL,
  `isActive` tinyint(1) NOT NULL,
  `UConexion` datetime NOT NULL,
  `Role` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `User`
--

INSERT INTO `User` (`id`, `username`, `salt`, `password`, `email`, `isActive`, `UConexion`, `Role`) VALUES
(1, 'Mario', '044ee3442ff43e2ea7190dcfc2730256', 'HlZ2Q57yW3P+V7CsLiGs6lQxirtYwiwPAuOMqrApP2B/ziaR2x6PuO1SSeeEw0M3H++m3K7gqg4yqejlgEN8Yg==', '100292688@alumnos.uc3m.es', 1, '2016-03-19 00:00:00', 1);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `Algoritmos`
--
ALTER TABLE `Algoritmos`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `Comparativa`
--
ALTER TABLE `Comparativa`
  ADD PRIMARY KEY (`id`,`test`),
  ADD KEY `test` (`test`);

--
-- Indices de la tabla `Configuracion`
--
ALTER TABLE `Configuracion`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `Estado`
--
ALTER TABLE `Estado`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `Ficheros`
--
ALTER TABLE `Ficheros`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `Programas`
--
ALTER TABLE `Programas`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `Resultado`
--
ALTER TABLE `Resultado`
  ADD PRIMARY KEY (`id`),
  ADD KEY `test` (`test`);

--
-- Indices de la tabla `Rol`
--
ALTER TABLE `Rol`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `ScriptBenchmark`
--
ALTER TABLE `ScriptBenchmark`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `Scripts`
--
ALTER TABLE `Scripts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `Algoritmo` (`Algoritmo`),
  ADD KEY `Programa` (`Programa`);

--
-- Indices de la tabla `Test`
--
ALTER TABLE `Test`
  ADD PRIMARY KEY (`id`),
  ADD KEY `Fichero` (`Fichero`,`Programa`,`Algoritmo`,`Estado`,`ScriptBenchmark`),
  ADD KEY `ScriptBenchmark` (`ScriptBenchmark`),
  ADD KEY `Programa` (`Programa`),
  ADD KEY `Estado` (`Estado`),
  ADD KEY `Algoritmo` (`Algoritmo`),
  ADD KEY `Configuracion` (`Configuracion`);

--
-- Indices de la tabla `User`
--
ALTER TABLE `User`
  ADD PRIMARY KEY (`id`),
  ADD KEY `Role` (`Role`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `Algoritmos`
--
ALTER TABLE `Algoritmos`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
--
-- AUTO_INCREMENT de la tabla `Configuracion`
--
ALTER TABLE `Configuracion`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=203;
--
-- AUTO_INCREMENT de la tabla `Estado`
--
ALTER TABLE `Estado`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;
--
-- AUTO_INCREMENT de la tabla `Ficheros`
--
ALTER TABLE `Ficheros`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;
--
-- AUTO_INCREMENT de la tabla `Programas`
--
ALTER TABLE `Programas`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
--
-- AUTO_INCREMENT de la tabla `Resultado`
--
ALTER TABLE `Resultado`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=118;
--
-- AUTO_INCREMENT de la tabla `Rol`
--
ALTER TABLE `Rol`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT de la tabla `ScriptBenchmark`
--
ALTER TABLE `ScriptBenchmark`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=187;
--
-- AUTO_INCREMENT de la tabla `Scripts`
--
ALTER TABLE `Scripts`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;
--
-- AUTO_INCREMENT de la tabla `Test`
--
ALTER TABLE `Test`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=186;
--
-- AUTO_INCREMENT de la tabla `User`
--
ALTER TABLE `User`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `Comparativa`
--
ALTER TABLE `Comparativa`
  ADD CONSTRAINT `Comparativa_ibfk_1` FOREIGN KEY (`test`) REFERENCES `Test` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `Resultado`
--
ALTER TABLE `Resultado`
  ADD CONSTRAINT `Resultado_ibfk_1` FOREIGN KEY (`test`) REFERENCES `Test` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `Scripts`
--
ALTER TABLE `Scripts`
  ADD CONSTRAINT `Scripts_ibfk_1` FOREIGN KEY (`Algoritmo`) REFERENCES `Algoritmos` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `Scripts_ibfk_2` FOREIGN KEY (`Programa`) REFERENCES `Programas` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `Test`
--
ALTER TABLE `Test`
  ADD CONSTRAINT `Test_ibfk_1` FOREIGN KEY (`ScriptBenchmark`) REFERENCES `ScriptBenchmark` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `Test_ibfk_2` FOREIGN KEY (`Programa`) REFERENCES `Programas` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `Test_ibfk_3` FOREIGN KEY (`Estado`) REFERENCES `Estado` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `Test_ibfk_4` FOREIGN KEY (`Fichero`) REFERENCES `Ficheros` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `Test_ibfk_5` FOREIGN KEY (`Algoritmo`) REFERENCES `Algoritmos` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `Test_ibfk_6` FOREIGN KEY (`Configuracion`) REFERENCES `Configuracion` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `User`
--
ALTER TABLE `User`
  ADD CONSTRAINT `User_ibfk_1` FOREIGN KEY (`Role`) REFERENCES `Rol` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
