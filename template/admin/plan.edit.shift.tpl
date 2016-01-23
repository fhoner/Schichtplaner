<tr class="tr-production">
    <td class="tr-production-uid readonly td-debug">${name}$</td>
    <td class="tr-production-name">${name}$</td>
    <td class="readonly">
        <table class="table table-bordered" style="margin-bottom:0px;">
            <tbody>
                <tr>
                    <td class="readonly" style="width:80px;"><strong>Name</strong></td>
                    <td class="tr-production-master-name">${masterName}$</td>
                </tr>
                <tr>
                    <td class="readonly"><strong>E-Mail</strong></td>
                    <td class="tr-production-master-email">${masterEmail}$</td>
                </tr>
            </tbody>
        </table>  
    </td>
    <td class="tr-production-shifts readonly" style="width:250px;">
        <table class="table table-bordered" style="margin-bottom:0px;">
            <thead>
                <tr>
                    <th>Uhrzeit</th>
                    <th>Helfer</th>
                </tr>
            </thead>
            <tbody>
                ${shifts}$
            </tbody>
        </table>
    </td>
    <td class="tr-shift-delete readonly" style="width:40px; text-align:center;">
        <span class="glyphicon glyphicon-trash" aria-hidden="true"></span>
    </td>
</tr>