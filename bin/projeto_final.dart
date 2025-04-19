import 'dart:convert';
import 'dart:io';

import 'package:yaansi/yaansi.dart';

void main() async {
  bool isRunning = true;
  while (isRunning) {
    print("Olá, Leandro. Que relatório você precisa?");
    print("1 - Temperatura");
    print("2 - Umidade");
    print("3 - Direção do vento");
    print("4 - Salvar relatório");
    print("5 - Teste rápido (roda todas as opções)");
    print("6 - Sair do programa");
    print("Digite o número da opção desejada: ");
    String? opt = stdin.readLineSync();

    //Cada inicialização gera um objeto "Relatorio"
    Relatorio relatorio = new Relatorio();

    switch (opt) {
      case "1":
        late dynamic opt1;
        late dynamic opt2;

        print("==========================");
        print("Insira a opção de estado: ");
        print("1 - SC");
        print("2 - SP");
        print("==========================");
        opt1 = stdin.readLineSync();

        if (opt1 == "1") {
          opt1 = "SC";
        } else if (opt1 == "2") {
          opt1 = "SP";
        }

        print("==========================");
        print("Insira a opção de mês em número:  ");
        opt2 = stdin.readLineSync();

        if (opt1 == "1") {
          opt1 = "SC";
        } else if (opt1 == "2") {
          opt1 = "SP";
        }

        //Lógica com mês específico
        try {
        final listaDeObj = gerarListaObj(opt1.toString(), opt2.toString());

        double tempMediaEstado =  await getTempMedEstadoMes(await listaDeObj);
        double tempMaxima = await getTempMaxEstadoMes(await listaDeObj);
        double tempMinima = await getTempMinEstadoMes(await listaDeObj);
        double tempMediaHora = await getTempMedEstadoHora(await listaDeObj);

        print("");
        print("===== Temperaturas =====");
        print("");
        print("===== Temperatura média do mês no estado de $opt1 =====");
          print("Celsius: ${red(tempMediaEstado.toStringAsFixed(2))}${red(" ºC")}");
          print("Fahrenheit: ${yellow(celsiusFahrenheit(await tempMediaEstado).toStringAsFixed(2))}${yellow(" ºF")}");
          print("Kelvin: ${blue(celsiusKelvin(await tempMediaEstado).toStringAsFixed(2))}${blue(" ºK")}");
        print("=========================================================");

          //Adicionar valores ao objeto "relatorio"
          relatorio.tempMediaEstadoMesC = tempMediaEstado;
          relatorio.tempMediaEstadoMesF = celsiusFahrenheit(tempMediaEstado);
          relatorio.tempMediaEstadoMesK = celsiusKelvin(tempMediaEstado);

        print("");
        print("===== Temperatura máxima do mês no estado $opt1 =====");
          print("Celsius: ${red(tempMaxima.toStringAsFixed(2))}${red(" ºC")}");
          print("Fahrenheit: ${yellow(celsiusFahrenheit(tempMaxima).toStringAsFixed(2))}${yellow(" ºF")}");
          print("Kelvin: ${blue(celsiusKelvin(tempMaxima).toStringAsFixed(2))}${blue(" ºK")}");
        print("=========================================================");

          //Adiciona valores ao objeto "relatorio"
          relatorio.tempMaxEstadoAnoC = tempMaxima;
          relatorio.tempMaxEstadoAnoF = celsiusFahrenheit(tempMaxima);
          relatorio.tempMaxEstadoAnoK = celsiusKelvin(tempMaxima);

        print("");
        print("===== Temperatura mínima do mês no estado $opt1 =====");
          print("Celsius: ${red(tempMinima.toStringAsFixed(2))}${red(" ºC")}");
          print("Fahrenheit: ${yellow(celsiusFahrenheit(await tempMinima).toStringAsFixed(2))}${yellow(" ºF")}");
          print("Kelvin: ${blue(celsiusKelvin(await tempMinima).toStringAsFixed(2))}${blue(" ºK")}");
        print("=========================================================");

        //Adiciona valores ao objeto "relatorio"
        relatorio.tempMinEstadoAnoC = tempMinima;
        relatorio.tempMinEstadoAnoF = celsiusFahrenheit(tempMinima);
        relatorio.tempMinEstadoAnoK = celsiusKelvin(tempMinima);

        print("");
        print("===== Temperatura média por hora do estado $opt1 =====");
          print("Celsius: ${red(tempMediaHora.toStringAsFixed(2))}${red(" ºC")}");
          print("Fahrenheit: ${yellow(celsiusFahrenheit(tempMaxima).toStringAsFixed(2))}${yellow(" ºF")}");
          print("Kelvin: ${blue(celsiusKelvin(tempMaxima).toStringAsFixed(2))}${blue(" ºK")}");
        print("=========================================================");

        //Adiciona valores ao objeto "relatorio"
        relatorio.tempHoraEstadoC = tempMediaHora;
        relatorio.tempHoraEstadoF = celsiusFahrenheit(tempMediaHora);
        relatorio.tempHoraEstadoK = celsiusKelvin(tempMediaHora);

        print("");
        print("Buscando dados referentes ao ano do estado selecionado, aguarde... ");

        //Lógica envolvendo o ano inteiro
        List<List<DataLine>> listaDeMeses = await getMeses(opt1.toString());
        double mediaAno = await getTempMedEstadoAno(listaDeMeses);
        double maxAno = await getTempMaxEstadoAno(listaDeMeses);
        double minAno = await getTempMinEstadoAno(listaDeMeses);

        print("===== Temperatura média anual $opt1 =====");
          print("Celsius: ${red(mediaAno.toStringAsFixed(2))}${red(" ºC")}");
          print("Fahrenheit: ${yellow(celsiusFahrenheit(await mediaAno).toStringAsFixed(2))}${yellow(" ºF")}");
          print("Kelvin: ${blue(celsiusKelvin(await mediaAno).toStringAsFixed(2))}${blue(" ºK")}");

          //Adiciona valores ao objeto "relatorio"
          relatorio.tempMediaEstadoAnoC = mediaAno;
          relatorio.tempMediaEstadoAnoF = celsiusFahrenheit(mediaAno);
          relatorio.tempMediaEstadoAnoK = celsiusKelvin(mediaAno);

        print("");
        print("===== Temperatura máxima anual $opt1 =====");
          print("Celsius: ${red(maxAno.toStringAsFixed(2))}${red(" ºC")}");
          print("Fahrenheit: ${yellow(celsiusFahrenheit(await maxAno).toStringAsFixed(2))}${red(" ºF")}");
          print("Kelvin: ${blue(celsiusKelvin(await maxAno).toStringAsFixed(2))}${blue(" ºK")}");

          //Adiciona valores ao objeto "relatorio"
          relatorio.tempMaxEstadoAnoC = maxAno;
          relatorio.tempMaxEstadoAnoF = celsiusFahrenheit(maxAno);
          relatorio.tempMaxEstadoAnoK = celsiusKelvin(maxAno);

        print("");
        print("===== Temperatura mínima anual $opt1 =====");
          print("Celsius: ${red(minAno.toStringAsFixed(2))}${red(" ºC")}");
          print("Fahrenheit: ${yellow(celsiusFahrenheit(minAno).toStringAsFixed(2))}${yellow(" ºF")}");
          print("Kelvin: ${blue(celsiusKelvin(minAno).toStringAsFixed(2))}${blue(" ºK")}");

          //Adiciona valores ao objeto "relatorio"
          relatorio.tempMinEstadoAnoC = minAno;
          relatorio.tempMinEstadoAnoF = celsiusFahrenheit(minAno);
          relatorio.tempMinEstadoAnoC = celsiusKelvin(minAno);

          print("");
          print("Busca concluída. Pressione enter para voltar ao menu");

        } catch (e){
          print(e);
        } finally {
          //Esse stdin aq faz o programa esperar um toque no enter pra depois rodar o loop do menu novamente
          stdin.readLineSync();
          consoleClear();
        }
        break;

      case "2":
        late dynamic opt1;
        late dynamic opt2;

        print("==========================");
        print("Insira a opção de estado: ");
        print("1 - SC");
        print("2 - SP");
        print("==========================");
        opt1 = stdin.readLineSync();

        if (opt1 == "1") {
          opt1 = "SC";
        } else if (opt1 == "2") {
          opt1 = "SP";
        }

        print("==========================");
        print("Insira a opção de mês em número:  ");
        opt2 = stdin.readLineSync();
        if(opt2 == null) {
          throw Exception("Mês inválido! Insira um mês pelo numeral");
        }

        try{
          //Trabalhando com mês específico
          final listaObj = gerarListaObj(opt1, opt2);

          double umidadeMediaMes = await getUmidadeMedEstadoMes(await listaObj);
          double umidadeMaxMes = await getUmidadeMaxEstadoMes(await listaObj);
          double umidadeMinMes = await getUmidadeMinEstadoMes(await listaObj);

          //Trabalhando com ano
          List<List<DataLine>> listaDeMeses = await getMeses(opt1);

          double umidadeMediaAno = await getUmidadeMedEstadoAno(await listaDeMeses);
          double umidadeMaxAno = await getUmidadeMaxEstadoAno(await listaDeMeses);
          double umidadeMinAno = await getUmidadeMinEstadoAno(await listaDeMeses);

          print("");
          print("===== Umidades =====");
          print("===== Umidade média do estado de $opt1 ====="); // g/m³
            print("Umidade: ${green(umidadeMediaMes.toStringAsFixed(2))}${green(" g/m³")}");
          print("");

          //Adiciona dados ao objeto "relatorio"
          relatorio.umidadeMediaEstadoMes = umidadeMediaMes;


          print("===== Umidade máxima do estado de $opt1 =====");
            print("Umidade: ${red(umidadeMaxMes.toStringAsFixed(2))}${red(" g/m³")}");
            print("");

          //Adiciona dados ao objeto "relatorio"
          relatorio.umidadeMaxEstadoMes = umidadeMaxMes;

          print("===== Umidade mínima do estado de $opt1 =====");
            print("Umidade: ${blue(umidadeMinMes.toStringAsFixed(2))}${blue(" g/m³")}");
            print("");

          //Adiciona dados ao objeto "relatorio"
          relatorio.umidadeMinEstadoMes = umidadeMinMes;

          print("Buscando valores referentes ao ano do estado de $opt1. Aguarde...");
            print("");

          print("===== Umidade média anual =====");
            print("Umidade: ${green(umidadeMediaAno.toStringAsFixed(2))}${green(" g/m³")}");
            print("");

          //Adiciona dados ao objeto "relatorio"
          relatorio.umidadeMediaEstadoAno = umidadeMediaAno;

          print("===== Umidade máxima anual =====");
            print("Umidade: ${red(umidadeMaxAno.toStringAsFixed(2))}${red(" g/m³")}");
            print("");

          //Adiciona dados ao objeto "relatorio"
          relatorio.umidadeMaxEstadoAno = umidadeMaxAno;

          print("Umidade mínima anual =====");
            print("Umidade: ${blue(umidadeMinAno.toStringAsFixed(2))}${blue(" g/m³")}");
            print("");

          //Adiciona dados ao objeto "relatorio"
          relatorio.umidadeMinEstadoAno = umidadeMinAno;

          print("Busca concluída. Pressione enter para voltar ao menu");

        } on Exception catch(e){
          print(e);
        } finally {
          //Esse stdin aq faz o programa esperar um toque no enter pra depois rodar o loop do menu novamente
          stdin.readLineSync();
          consoleClear();
        }
        break;

      case "3":
        try {
          
        late dynamic opt1;
        late dynamic opt2;

        print("==========================");
        print("Insira a opção de estado: ");
        print("1 - SC");
        print("2 - SP");
        print("==========================");
        opt1 = stdin.readLineSync();

        if (opt1 == "1") {
          opt1 = "SC";
        } else if (opt1 == "2") {
          opt1 = "SP";
        }

        print("==========================");
        print("Insira a opção de mês em número:  ");
        opt2 = stdin.readLineSync();

        //Trabalhando com mês em específico
        final listaDeObj = gerarListaObj(opt1, opt2);

        final int direcaoVentoFrequenteMes = await getDirecaoVentoFrequenteMes(await listaDeObj);

        print("");
        print("===== Direção do vento mais frequente no estado de $opt1 =====");
          print("Direção: ${yellow(direcaoVentoFrequenteMes.toString())}${yellow(" º")}");
          print("Direção: ${yellow(grausRadianos(direcaoVentoFrequenteMes).toStringAsFixed(2))}${yellow(" rad")}");

        //Adiciona dados ao objeto "relatorio"
        relatorio.direcaoMaiorFrequenciaEstado = direcaoVentoFrequenteMes;

        print("");
        print("Buscando valores referentes ao ano do estado de $opt1. Aguarde...");
        print("");

        //Trabalhando com ano
        final List<List<DataLine>> listaDeMeses = await getMeses(opt1);
        final int direcaoVentoFrequenteAno = await getDirecaoVentoFrequenteAno(listaDeMeses);


        print("===== Direção do vento mais frequente do ano no estado de $opt1 =====");
        print("Direção: ${yellow(direcaoVentoFrequenteAno.toString())}${yellow(" º")}");
        print("Direção: ${yellow(grausRadianos(direcaoVentoFrequenteAno).toStringAsFixed(2))}${yellow(" rad")}");

        //Adiciona dados ao objeto "relatorio"
        relatorio.direcaoMaiorFrequenciaAno = direcaoVentoFrequenteAno;

        print("Busca concluída. Pressione enter para voltar ao menu");

        } on Exception catch(e){
          print(e);
        } finally {
          //Esse stdin aq faz o programa esperar um toque no enter pra depois rodar o loop do menu novamente
          stdin.readLineSync();
          consoleClear();
        }
        break;

      case "4":
        try {
          salvarArquivoTxt(relatorio);
          print("Relatório salvo com sucesso em relatoriosTeste/relatorio.txt");
        } catch (e) {
          print("Erro ao salvar o relatório: $e");
        } finally {
          stdin.readLineSync();
          consoleClear();
        }
        break;

      case "5":
        print("Executando teste rápido para TODOS os meses do estado SC...\n");

        String estadoPadrao = "SC";
        Relatorio relatorio = new Relatorio();

        try {
          for (int mes = 1; mes <= 12; mes++) {
            print(magenta("================ MÊS: $mes ==============="));

            final listaObj = await gerarListaObj(estadoPadrao, mes.toString());

            double tempMedia = await getTempMedEstadoMes(listaObj);
            double tempMax = getTempMaxEstadoMes(listaObj);
            double tempMin = await getTempMinEstadoMes(listaObj);
            double tempHora = await getTempMedEstadoHora(listaObj);

            double umidadeMedia = await getUmidadeMedEstadoMes(listaObj);
            double umidadeMax = getUmidadeMaxEstadoMes(listaObj);
            double umidadeMin = await getUmidadeMinEstadoMes(listaObj);

            int direcaoVentoMes = await getDirecaoVentoFrequenteMes(listaObj);

            print("========== Temperatura média ==========");
            print("Celsius: ${red(tempMedia.toStringAsFixed(2))} ${red(" ºC")} ");
            print("Fahrenheit: ${yellow(celsiusFahrenheit(tempMedia).toStringAsFixed(2))} ${yellow(" ºF")}");
            print("Kelvin: ${blue(celsiusKelvin(tempMedia).toStringAsFixed(2))} ${blue(" ºK")}  ");
            print("\n");

            print("========== Temperatura Máxima ==========");
            print("Celsius: ${red(tempMax.toStringAsFixed(2))} ${red(" ºC")} ");
            print("Fahrenheit: ${yellow(celsiusFahrenheit(tempMax).toStringAsFixed(2))} ${yellow(" ºF")}");
            print("Kelvin: ${blue(celsiusKelvin(tempMax).toStringAsFixed(2))} ${blue(" ºK")}  ");
            print("\n");

            print("========== Temperatura Mínima ==========");
            print("Celsius: ${red(tempMin.toStringAsFixed(2))} ${red(" ºC")} ");
            print("Fahrenheit: ${yellow(celsiusFahrenheit(tempMin).toStringAsFixed(2))} ${yellow(" ºF")}");
            print("Kelvin: ${blue(celsiusKelvin(tempMin).toStringAsFixed(2))} ${blue(" ºK")}  ");
            print("\n");

            print("========== Temperatura Média p/ hora ==========");
            print("Celsius: ${red(tempHora.toStringAsFixed(2))} ${red(" ºC")} ");
            print("Fahrenheit: ${yellow(celsiusFahrenheit(tempHora).toStringAsFixed(2))} ${yellow(" ºF")}");
            print("Kelvin: ${blue(celsiusKelvin(tempHora).toStringAsFixed(2))} ${blue(" ºK")}  ");
            print("\n");

            print("Umidade Média: ${green(umidadeMedia.toStringAsFixed(2))} ${green(" g/m³")}");
            print("Umidade Máxima: ${red(umidadeMax.toStringAsFixed(2))} ${red(" g/m³")}");
            print("Umidade Mínima: ${blue(umidadeMin.toStringAsFixed(2))} ${blue(" g/m³")}");

            print("Direção do Vento + Frequente: ${yellow(direcaoVentoMes.toString())}${yellow(" °")}");
            print("Direção do Vento + Frequente: ${yellow(grausRadianos(direcaoVentoMes).toStringAsFixed(2))}${yellow(" rad")}");

            print("=============================\n");
          }

          print("Calculando dados anuais... Aguarde...\n");

          final listaDeMeses = await getMeses(estadoPadrao);

          // Temperatura Anual
          relatorio.tempMediaEstadoAnoC = await getTempMedEstadoAno(listaDeMeses);
          relatorio.tempMediaEstadoAnoF = celsiusFahrenheit(relatorio.tempMediaEstadoAnoC);
          relatorio.tempMediaEstadoAnoK = celsiusKelvin(relatorio.tempMediaEstadoAnoC);

          relatorio.tempMaxEstadoAnoC = await getTempMaxEstadoAno(listaDeMeses);
          relatorio.tempMaxEstadoAnoF = celsiusFahrenheit(relatorio.tempMaxEstadoAnoC);
          relatorio.tempMaxEstadoAnoK = celsiusKelvin(relatorio.tempMaxEstadoAnoC);

          relatorio.tempMinEstadoAnoC = await getTempMinEstadoAno(listaDeMeses);
          relatorio.tempMinEstadoAnoF = celsiusFahrenheit(relatorio.tempMinEstadoAnoC);
          relatorio.tempMinEstadoAnoK = celsiusKelvin(relatorio.tempMinEstadoAnoC);

          // Umidade Anual
          relatorio.umidadeMediaEstadoAno = await getUmidadeMedEstadoAno(listaDeMeses);
          relatorio.umidadeMaxEstadoAno = await getUmidadeMaxEstadoAno(listaDeMeses);
          relatorio.umidadeMinEstadoAno = await getUmidadeMinEstadoAno(listaDeMeses);

          // Vento Anual
          relatorio.direcaoMaiorFrequenciaAno = await getDirecaoVentoFrequenteAno(listaDeMeses);

          print(magenta("========= RELATÓRIO ANUAL ($estadoPadrao) ========="));
          
          print("========== Temperatura Média ==========");
          print("Celsius: ${red(relatorio.tempMediaEstadoAnoC.toStringAsFixed(2))} ${red(" ºC")} ");
          print("Fahrenheit: ${yellow(celsiusFahrenheit(relatorio.tempMediaEstadoAnoC).toStringAsFixed(2))} ${yellow(" ºF")}");
          print("Kelvin: ${blue(celsiusKelvin(relatorio.tempMediaEstadoAnoC).toStringAsFixed(2))} ${blue(" ºK")}  ");
          print("\n");
          
          print("========== Temperatura Máxima ==========");
          print("Celsius: ${red(relatorio.tempMaxEstadoAnoC.toStringAsFixed(2))} ${red(" ºC")} ");
          print("Fahrenheit: ${yellow(celsiusFahrenheit(relatorio.tempMaxEstadoAnoC).toStringAsFixed(2))} ${yellow(" ºF")}");
          print("Kelvin: ${blue(celsiusKelvin(relatorio.tempMaxEstadoAnoC).toStringAsFixed(2))} ${blue(" ºK")}  ");
          print("\n");
          
          print("========== Temperatura Mìnima ==========");
          print("Celsius: ${red(relatorio.tempMinEstadoAnoC.toStringAsFixed(2))} ${red(" ºC")} ");
          print("Fahrenheit: ${yellow(celsiusFahrenheit(relatorio.tempMinEstadoAnoC).toStringAsFixed(2))} ${yellow(" ºF")}");
          print("Kelvin: ${blue(celsiusKelvin(relatorio.tempMinEstadoAnoC).toStringAsFixed(2))} ${blue(" ºK")}  ");
          print("\n");

          print("Umidade Média: ${green(relatorio.umidadeMediaEstadoAno.toStringAsFixed(2))} ${green(" g/m³")}");
          print("Umidade Máxima: ${red(relatorio.umidadeMaxEstadoAno.toStringAsFixed(2))} ${red(" g/m³")}");
          print("Umidade Mínima: ${blue(relatorio.umidadeMinEstadoAno.toStringAsFixed(2))} ${blue(" g/m³")}");

          print("Direção do Vento + Frequente: ${yellow(relatorio.direcaoMaiorFrequenciaAno.toString())}${yellow(" °")}");
          print("Direção do Vento + Frequente: ${yellow(grausRadianos(relatorio.direcaoMaiorFrequenciaAno).toStringAsFixed(2))}${yellow(" rad")}");
          print("==============================================\n");

          //Teste rápido SP
          print("Executando teste rápido para TODOS os meses do estado SC...\n");

          estadoPadrao = "SP";
          Relatorio relatorioSP = new Relatorio();

          for (int mes = 1; mes <= 12; mes++) {
            print(magenta("================ MÊS: $mes ==============="));

            final listaObj = await gerarListaObj(estadoPadrao, mes.toString());

            double tempMedia = await getTempMedEstadoMes(listaObj);
            double tempMax = getTempMaxEstadoMes(listaObj);
            double tempMin = await getTempMinEstadoMes(listaObj);
            double tempHora = await getTempMedEstadoHora(listaObj);

            double umidadeMedia = await getUmidadeMedEstadoMes(listaObj);
            double umidadeMax = getUmidadeMaxEstadoMes(listaObj);
            double umidadeMin = await getUmidadeMinEstadoMes(listaObj);

            int direcaoVentoMes = await getDirecaoVentoFrequenteMes(listaObj);

            print("========== Temperatura média ==========");
            print("Celsius: ${red(tempMedia.toStringAsFixed(2))} ${red(" ºC")} ");
            print("Fahrenheit: ${yellow(celsiusFahrenheit(tempMedia).toStringAsFixed(2))} ${yellow(" ºF")}");
            print("Kelvin: ${blue(celsiusKelvin(tempMedia).toStringAsFixed(2))} ${blue(" ºK")}  ");
            print("\n");

            print("========== Temperatura Máxima ==========");
            print("Celsius: ${red(tempMax.toStringAsFixed(2))} ${red(" ºC")} ");
            print("Fahrenheit: ${yellow(celsiusFahrenheit(tempMax).toStringAsFixed(2))} ${yellow(" ºF")}");
            print("Kelvin: ${blue(celsiusKelvin(tempMax).toStringAsFixed(2))} ${blue(" ºK")}  ");
            print("\n");

            print("========== Temperatura Mínima ==========");
            print("Celsius: ${red(tempMin.toStringAsFixed(2))} ${red(" ºC")} ");
            print("Fahrenheit: ${yellow(celsiusFahrenheit(tempMin).toStringAsFixed(2))} ${yellow(" ºF")}");
            print("Kelvin: ${blue(celsiusKelvin(tempMin).toStringAsFixed(2))} ${blue(" ºK")}  ");
            print("\n");

            print("========== Temperatura Média p/ hora ==========");
            print("Celsius: ${red(tempHora.toStringAsFixed(2))} ${red(" ºC")} ");
            print("Fahrenheit: ${yellow(celsiusFahrenheit(tempHora).toStringAsFixed(2))} ${yellow(" ºF")}");
            print("Kelvin: ${blue(celsiusKelvin(tempHora).toStringAsFixed(2))} ${blue(" ºK")}  ");
            print("\n");

            print("Umidade Média: ${green(umidadeMedia.toStringAsFixed(2))} ${green(" g/m³")}");
            print("Umidade Máxima: ${red(umidadeMax.toStringAsFixed(2))} ${red(" g/m³")}");
            print("Umidade Mínima: ${blue(umidadeMin.toStringAsFixed(2))} ${blue(" g/m³")}");

            print("Direção do Vento + Frequente: ${yellow(direcaoVentoMes.toString())}${yellow(" °")}");
            print("Direção do Vento + Frequente: ${yellow(grausRadianos(relatorioSP.direcaoMaiorFrequenciaAno).toStringAsFixed(2))}${yellow(" rad")}");

            print("=============================\n");
          }

          print("Calculando dados anuais... Aguarde...\n");

          // Temperatura Anual
          relatorioSP.tempMediaEstadoAnoC = await getTempMedEstadoAno(listaDeMeses);
          relatorioSP.tempMediaEstadoAnoF = celsiusFahrenheit(relatorioSP.tempMediaEstadoAnoC);
          relatorioSP.tempMediaEstadoAnoK = celsiusKelvin(relatorioSP.tempMediaEstadoAnoC);

          relatorioSP.tempMaxEstadoAnoC = await getTempMaxEstadoAno(listaDeMeses);
          relatorioSP.tempMaxEstadoAnoF = celsiusFahrenheit(relatorioSP.tempMaxEstadoAnoC);
          relatorioSP.tempMaxEstadoAnoK = celsiusKelvin(relatorioSP.tempMaxEstadoAnoC);

          relatorioSP.tempMinEstadoAnoC = await getTempMinEstadoAno(listaDeMeses);
          relatorioSP.tempMinEstadoAnoF = celsiusFahrenheit(relatorioSP.tempMinEstadoAnoC);
          relatorioSP.tempMinEstadoAnoK = celsiusKelvin(relatorioSP.tempMinEstadoAnoC);

          // Umidade Anual
          relatorioSP.umidadeMediaEstadoAno = await getUmidadeMedEstadoAno(listaDeMeses);
          relatorioSP.umidadeMaxEstadoAno = await getUmidadeMaxEstadoAno(listaDeMeses);
          relatorioSP.umidadeMinEstadoAno = await getUmidadeMinEstadoAno(listaDeMeses);

          // Vento Anual
          relatorioSP.direcaoMaiorFrequenciaAno = await getDirecaoVentoFrequenteAno(listaDeMeses);

          print(magenta("========= RELATÓRIO ANUAL ($estadoPadrao) ========="));

          print("========== Temperatura Média ==========");
          print("Celsius: ${red(relatorioSP.tempMediaEstadoAnoC.toStringAsFixed(2))} ${red(" ºC")} ");
          print("Fahrenheit: ${yellow(celsiusFahrenheit(relatorioSP.tempMediaEstadoAnoC).toStringAsFixed(2))} ${yellow(" ºF")}");
          print("Kelvin: ${blue(celsiusKelvin(relatorioSP.tempMediaEstadoAnoC).toStringAsFixed(2))} ${blue(" ºK")}  ");
          print("\n");

          print("========== Temperatura Máxima ==========");
          print("Celsius: ${red(relatorioSP.tempMaxEstadoAnoC.toStringAsFixed(2))} ${red(" ºC")} ");
          print("Fahrenheit: ${yellow(celsiusFahrenheit(relatorioSP.tempMaxEstadoAnoC).toStringAsFixed(2))} ${yellow(" ºF")}");
          print("Kelvin: ${blue(celsiusKelvin(relatorioSP.tempMaxEstadoAnoC).toStringAsFixed(2))} ${blue(" ºK")}  ");
          print("\n");

          print("========== Temperatura Mìnima ==========");
          print("Celsius: ${red(relatorioSP.tempMinEstadoAnoC.toStringAsFixed(2))} ${red(" ºC")} ");
          print("Fahrenheit: ${yellow(celsiusFahrenheit(relatorioSP.tempMinEstadoAnoC).toStringAsFixed(2))} ${yellow(" ºF")}");
          print("Kelvin: ${blue(celsiusKelvin(relatorioSP.tempMinEstadoAnoC).toStringAsFixed(2))} ${blue(" ºK")}  ");
          print("\n");

          print("Umidade Média: ${green(relatorioSP.umidadeMediaEstadoAno.toStringAsFixed(2))} ${green(" g/m³")}");
          print("Umidade Máxima: ${red(relatorioSP.umidadeMaxEstadoAno.toStringAsFixed(2))} ${red(" g/m³")}");
          print("Umidade Mínima: ${blue(relatorioSP.umidadeMinEstadoAno.toStringAsFixed(2))} ${blue(" g/m³")}");

          print("Direção do Vento + Frequente: ${yellow(relatorioSP.direcaoMaiorFrequenciaAno.toString())}${yellow(" °")}");
          print("Direção do Vento + Frequente: ${yellow(grausRadianos(relatorioSP.direcaoMaiorFrequenciaAno).toStringAsFixed(2))}${yellow(" rad")}");
          print("==============================================\n");

        } catch (e) {
          print("Erro durante o teste rápido: $e");
        } finally {
          print("Pressione ENTER para voltar ao menu...");
          stdin.readLineSync();
          consoleClear();
        }
        break;

      case "6":
        print("... FIM ...");
        isRunning = false;
        break;

      default:
        print(
          "Opção inválida. Por favor insira apenas um dos numerias referentes às escolhas do menu.",
        );
        stdin.readLineSync();
        break;
    }
  }
}

//TODO - Aqui fica o começo das funções e classes

double grausRadianos(int graus){
  double rad = 0;
  rad =  graus * (3.14/180);
  return rad;
}

void salvarArquivoTxt(Relatorio relatorio) async {
  final dir = Directory('relatoriosTeste');

  // Cria a pasta se não existir
  if (!(await dir.exists())) {
    await dir.create(recursive: true);
  }

  final arquivo = File('${dir.path}/relatorio_${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}_'
      '${DateTime.now().hour}_${DateTime.now().minute}_${DateTime.now().second}.txt');
  await arquivo.writeAsString(relatorio.toString());
}

class Relatorio {
  //Requisitos de Temperatura - unidades -> C Celisus - F Fahrenheit - K Kelvin
  late double tempMediaEstadoAnoC = 0;
  late double tempMediaEstadoAnoF = 0;
  late double tempMediaEstadoAnoK = 0;
  late double tempMaxEstadoAnoC = 0;
  late double tempMaxEstadoAnoF = 0;
  late double tempMaxEstadoAnoK = 0;
  late double tempMinEstadoAnoC = 0;
  late double tempMinEstadoAnoF = 0;
  late double tempMinEstadoAnoK = 0;
  late double tempMediaEstadoMesC = 0;
  late double tempMediaEstadoMesF = 0;
  late double tempMediaEstadoMesK = 0;
  late double tempMaxEstadoMesC = 0;
  late double tempMaxEstadoMesF = 0;
  late double tempMaxEstadoMesK = 0;
  late double tempMinEstadoMesC = 0;
  late double tempMinEstadoMesF = 0;
  late double tempMinEstadoMesK = 0;
  late double tempHoraEstadoC = 0;
  late double tempHoraEstadoF = 0;
  late double tempHoraEstadoK = 0;

  //Requisitos de Umidade do ar
  late double umidadeMediaEstadoAno = 0;
  late double umidadeMinEstadoAno = 0;
  late double umidadeMaxEstadoAno = 0;
  late double umidadeMediaEstadoMes = 0;
  late double umidadeMaxEstadoMes = 0;
  late double umidadeMinEstadoMes = 0;

  //Requisitos Direção do vento - unidades -> graus radianos
  late int direcaoMaiorFrequenciaEstado = 0;
  late int direcaoMaiorFrequenciaAno = 0;

  @override
  String toString() {
    return '''
    === Relatório de Dados Meteorológicos ===

    --- Temperaturas ---
    
    _> Médias do estado por mês
    Celsius: $tempMediaEstadoMesC
    Fahrenheit: $tempMediaEstadoMesF
    Kelvin: $tempMediaEstadoMesK
    
    _> Máximas do estado por mês
    Celsius: $tempMaxEstadoMesC
    Fahrenheit: $tempMaxEstadoMesF
    Kelvin: $tempMaxEstadoMesK
    
    _> Mínimas do estado por mês
    Celsius: $tempMinEstadoMesC
    Fahrenheit: $tempMinEstadoMesF
    Kelvin: $tempMinEstadoMesK
    
    _> Média por hora do estado
    Celsius: $tempHoraEstadoC
    Fahrenheit: $tempHoraEstadoF
    Kelvin: $tempHoraEstadoK
    
    --- Temperaturas anuais ---
  
    _> Média por ano:
    Celsius: $tempMediaEstadoAnoC
    Fahrenheit: $tempMediaEstadoAnoF
    Kelvin: $tempMediaEstadoAnoK
    
    _> Máxima por ano
    Celsius: $tempMaxEstadoAnoC
    Fahrenheit: $tempMaxEstadoAnoF
    Kelvin: $tempMaxEstadoAnoK
    
    _> Mínimas por ano
    Celsius: $tempMinEstadoAnoC
    Fahrenheit: $tempMinEstadoAnoF
    Kelvin: $tempMinEstadoAnoK
    
    --- Umidades ---
    
    _> Umidade média do estado
      Umidade: $umidadeMediaEstadoMes
      
    _> Umidade máxima do estado
      Umidade: $umidadeMaxEstadoMes
      
    _> Umidade mínima do estado
      Umidade: $umidadeMinEstadoMes
      
    _> Umidade média do ano
      Umidade: $umidadeMediaEstadoAno
      
    _> Umidade máxima do ano
      Umidade: $umidadeMaxEstadoAno
      
    _> Umidade mínima do ano
      Umidade: $umidadeMinEstadoAno
      
    --- Direção do Vento ---
    
    _> Direção do vento mais frequente no mês
    Direção: $direcaoMaiorFrequenciaEstado
    
    _> Direção do vento mais frequente no ano
    Direção: $direcaoMaiorFrequenciaAno

    =========================================
    ''';
  }
}

//Função pra converter celsius pra kelvin
double celsiusKelvin(double grausCelsius) => grausCelsius + 273.15;

//Função pra converter celsius pra fahrenheit
double celsiusFahrenheit(double grausCelsius) => grausCelsius * 1.8 + 32;

//Função pra conseguir a direção do vento mais frequente do ano
Future<int> getDirecaoVentoFrequenteAno(List<List<DataLine>> listaMeses) async{

  Map<int, int> listaGraus = {};
  List<int> valoresDeGrau = []; //Aqui vai ter as frequências mais altas de cada mês

  for (var mes in listaMeses) {
    valoresDeGrau.add(await getDirecaoVentoFrequenteMes(mes));
  }

  for(int i = 0; i < valoresDeGrau.length; i++){
    listaGraus[valoresDeGrau[i]] = (listaGraus[valoresDeGrau[i]] ?? 0) + 1;
  }

  int grauMaisFrequente = listaGraus.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  return Future.value(grauMaisFrequente);
}

//Função pra conseguir a direção mais frequente do vento do mês
Future<int> getDirecaoVentoFrequenteMes(List<DataLine> listaObj) {
  Map<int,int> listaDeGraus = {};

  for ( var grau in listaObj) {
    listaDeGraus[grau.direcaoVento] = (listaDeGraus[grau] ?? 0) + 1;
  }

  int grauMaisFrequente = listaDeGraus.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  return Future.value(grauMaisFrequente);
}


Future<double> getUmidadeMinEstadoAno(List<List<DataLine>> listaMeses) async {
  double min = await getUmidadeMaxEstadoAno(await listaMeses);

  for (int i = 0; i < listaMeses.length; i++) {
    for (int j = 0; j < listaMeses[i].length; j++) {
      if (min > listaMeses[i][j].umidade) {
        min = listaMeses[i][j].umidade;
      }
    }
  }
  return min;
}

//Função pra conseguir umidade máxima do ano
Future<double> getUmidadeMaxEstadoAno(List<List<DataLine>> listaMeses) async {
  double max = 0;

  for (int i = 0; i < listaMeses.length; i++) {
    for (int j = 0; j < listaMeses[i].length; j++) {
      if (max < listaMeses[i][j].umidade) {
        max = listaMeses[i][j].umidade;
      }
    }
  }
  return max;
}

//Função pra conseguir média de umidade do ano
Future<double> getUmidadeMedEstadoAno(List<List<DataLine>> listaMeses) async {
  double media = 0;
  int totalAdicoes = 0;
  for (int i = 0; i < listaMeses.length; i++) {
    for (int j = 0; j < listaMeses[i].length; j++) {
      media += listaMeses[i][j].umidade;
      totalAdicoes++;
    }
  }
  media = media / totalAdicoes;
  return media;
}

//Função pra conseguir umidade mínima do mês
Future<double> getUmidadeMinEstadoMes(List<DataLine> listaDeObj) async {
  double min = await getTempMaxEstadoMes(listaDeObj);
  for (DataLine objeto in listaDeObj) {
    if (min > objeto.umidade) {
      min = objeto.umidade;
    }
  }
  return min;
}

//Função pra conseguir umidade máxima do mês em questão
double getUmidadeMaxEstadoMes(List<DataLine> listaDeObj) {
  double max = 0;
  for (DataLine obj in listaDeObj) {
    if (max < obj.umidade) {
      max = obj.umidade;
    }
  }
  return max;
}

//Função pra conseguir a umidade média do mês
Future<double> getUmidadeMedEstadoMes(List<DataLine> listaDeObj) async {
  double media = 0;
  for (DataLine obj in listaDeObj) {
    media += obj.umidade;
  }
  media = media / listaDeObj.length;
  return media;
}

//Função pra conseguir temperatura mínima do ano do estado
Future<double> getTempMinEstadoAno(List<List<DataLine>> listaMeses) async {
  double min = await getTempMaxEstadoAno(await listaMeses);

  for (int i = 0; i < listaMeses.length; i++) {
    for (int j = 0; j < listaMeses[i].length; j++) {
      if (min > listaMeses[i][j].temperatura) {
        min = listaMeses[i][j].temperatura;
      }
    }
  }
  return min;
}

//Função pra conseguir temperatura máxima do ano do estado
Future<double> getTempMaxEstadoAno(List<List<DataLine>> listaMeses) async {
  double max = 0;
  for (int i = 0; i < listaMeses.length; i++) {
    for (int j = 0; j < listaMeses[i].length; j++) {
      if (max < listaMeses[i][j].temperatura) {
        max = listaMeses[i][j].temperatura;
      }
    }
  }
  return max;
}

//Função pra conseguir a média de temperatura do ano um estado
Future<double> getTempMedEstadoAno(List<List<DataLine>> listaMeses) async {
  double mediaAno = 0;
  int totalAdicoes = 0;
  for (int i = 0; i < listaMeses.length; i++) {
    for (int j = 0; j < listaMeses[i].length; j++) {
      mediaAno += listaMeses[i][j].temperatura;
      totalAdicoes++;
    }
  }
  mediaAno = mediaAno / totalAdicoes;
  return mediaAno;
}

//Função pra conseguir todos os meses de um estado
Future<List<List<DataLine>>> getMeses(String userPath) async {
  List<List<DataLine>> listaMeses = []; //Acho que esse é o caminho...
  for (int i = 1; i < 12; i++) {
    final listaDeObj = gerarListaObj(userPath, "${i}");
    listaMeses.add(await listaDeObj);
  }
  return listaMeses;
}

//Função pra conseguir a temperatura média de cada estado por hora
Future<double> getTempMedEstadoHora(List<DataLine> listaDeObj) async {
  List<double> valores = [];
  double media = 0;
  for (int i = 0; i < 25; i++) {
    valores.add(listaDeObj[i].temperatura);
  }

  for (int i = 0; i < valores.length; i++) {
    media += valores[i];
  }
  media = media / valores.length;
  return media;
}

//Função pra conseguir temperatura mínima de cada estado por mês
Future<double> getTempMinEstadoMes(List<DataLine> listaDeObj) async {
  double min = await getTempMaxEstadoMes(listaDeObj);
  for (DataLine objeto in listaDeObj) {
    if (min > objeto.temperatura) {
      min = objeto.temperatura;
    }
  }
  return min;
}

//Função pra conseguir temperatura máxima de cada estado por mês
double getTempMaxEstadoMes(List<DataLine> listaDeObj) {
  double max = 0;
  for (DataLine obj in listaDeObj) {
    if (max < obj.temperatura) {
      max = obj.temperatura;
    }
  }
  return max;
}

//Função pra conseguir temperatura média de cada estado por mês
Future<double> getTempMedEstadoMes(List<DataLine> listaDeObj) async {
  double media = 0;
  for (DataLine obj in listaDeObj) {
    media += obj.temperatura;
  }
  media = media / listaDeObj.length;
  return media;
}

Future<List<DataLine>> gerarListaObj(String userPath, String mes) async {
  List<String> lista = await lerArquivoCSV(userPath, mes,);
  List<DataLine> listaObjetos = [];
  for (int i = 1; i < lista.length; i++) {
    //Index começa em 1, pra pular o header da tabela de dados
    var obj = gerarObj(userPath, i);
    listaObjetos.add(await obj);
  }
  return listaObjetos;
}

//Retorna cada linha como uma string dentro de uma lista
Future<List<String>> lerArquivoCSV(String userPath, String mes) async {
  final arquivo = File("C:/clima/sensores/${userPath}_2024_$mes.csv");
  final linhas =
      await arquivo
          .openRead()
          .transform(latin1.decoder) // <- aqui o pulo do gato
          .transform(LineSplitter())
          .toList();
  return linhas;
  //Retorna uma lista de elementos "linha". Cada "linha" representa a linha de dados do Excel
}

//Pega elemento "linha" e split por (","). Retorna uma lista de Strings, cada String é um valor daquela uma linha
//Planejo usar esse méthod em um for
List<String> tratarDados(String linha) {
  List<String> dadosDaLinha = linha.split(",");
  return dadosDaLinha;
}

//Method responsável por criar um objeto que representa a linha de dados do arquivo
Future<DataLine> gerarObj(String userPath, int index) async {
  final dados = await lerArquivoCSV(userPath.toString(), "1");
  final linha = tratarDados(dados[index]);

  DataLine d = new DataLine();
  d.mes = int.parse(linha[0]);
  d.dia = int.parse(linha[1]);
  d.hora = int.parse(linha[2]);
  d.temperatura = double.parse(linha[3]);
  d.umidade = double.parse(linha[4]);
  d.densidadeAr = double.parse(linha[5]);
  d.velocidadeVento = double.parse(linha[6]);
  d.direcaoVento = int.parse(linha[7]);

  return d;
}

abstract class dadosOrganizados {
  //Classe que deixa os dados de forma mais acessível. Cada linha será um objeto
  late int mes;
  late int dia;
  late int hora;
  late double temperatura;
  late double umidade;
  late double densidadeAr;
  late double velocidadeVento;
  late int direcaoVento;
}

class DataLine extends dadosOrganizados {}

void consoleClear() {
  print('\n' * 100);
}