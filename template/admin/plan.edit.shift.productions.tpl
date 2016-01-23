<tr class="production-shift-entry">
    <td class="readonly" onclick="toggle($(this).parent());">
        <input onclick="toggle($(this).parent());" class="production-shift-entry-name" type="checkbox" value="${value}$" ${checked}$ />
        &nbsp;${name}$<br />
    </td>
    <td class="readonly" style="width:40px;">
        <input type="number" class="form-input production-shift-entry-required" value="${workers}$" style="width: 100%;" min="0" max="20" />
    </td>
</tr>