<!doctype html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <style>
            body {
                font-family: "Helvetica";
                margin-right:60px;
                font-weight:400;
            }
            .hidden {
                display:none;
            }
            table {
                border-collapse: collapse;
                width: 100%;
                
            }
            th {
                height:60px;
            }
            td {
                padding:5px;
                font-size:12px;
            }
            .short {
                width:60px;
            }
            td.td-time {
                text-align: center;
                vertical-align: middle !important;
                height:100px;
                white-space:normal !important;
            }
            .td-user {
                vertical-align: top !important;
                padding:0px;
                background-color: #ccc;
                border:0px;
            }
            .td-user td {
                background-color:#ccffcd;
                border:1px solid black;
            }
            .td-user .user-email {
                display: none;
            }
            .td-disabled {
                background-color: #eee;
            }
            .delete-user {
                width:20px;
                text-align: center;
            }
            .tr-debug {
                display:none;
            }   
            .tbl-worker * {
                background-color:transparent !important;
                border:0px!important;
                padding:0px;
                margin:0px;
            }
            small {
                font-weight:100;
            }   
            #footer {
                position: fixed;
                bottom: 0px;
                left: 0px;
                right: 0px;
                height: 40px;
                background-color: #eee;
                border-top: 2px solid silver;
            }
            .pagenum:before {
                content: counter(page);
            }
            .missing {
                background-image: linear-gradient(-45deg, black 25%, transparent 25%, transparent 50%, black 50%, black 75%, transparent 75%, transparent);
                background-size: 4px 4px;
            }
        </style>
    </head>
    <body>
    <div id="footer">
        <table style="border: 0px !important; width:100%;">
            <tr>
                <td>&copy; 2016 Schichtplaner 1.0 - Felix Honer, MV &Ouml;schelbronn e. V.</td>
                <td style="text-align:right;">Seite <span class="pagenum"></span></td>
            </tr>
        </table>
    </div>
    
    <table style="border:0px; width:100%;">
        <tr>
            <td><h1>Schichtplan ${name}$</h1></td>
            <td style="text-align:right;"><h4>Stand: ${date}$</h4></td>
        </tr>
    </table>
    
    ${content}$
    </body>
</html>