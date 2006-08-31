<?php
/******************************************************************************
 * Uebersicht und Pflege aller Rollen-Kategorien
 *
 * Copyright    : (c) 2004 - 2006 The Admidio Team
 * Homepage     : http://www.admidio.org
 * Module-Owner : Markus Fassbender
 *
 ******************************************************************************
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
 *
 ****************************************************************************/
 
require("../../system/common.php");
require("../../system/login_valid.php");

// nur Moderatoren duerfen Kategorien erfassen & verwalten
if(!isModerator())
{
    $g_message->show("norights");
}

// wenn URL uebergeben wurde zu dieser gehen, ansonsten zurueck
if(array_key_exists('url', $_GET))
{
    $url = $_GET['url'];
}
else
{
    $url = urlencode(getHttpReferer());
}

echo "
<!-- (c) 2004 - 2006 The Admidio Team - http://www.admidio.org - Version: ". getVersion(). " -->\n
<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">
<html>
<head>
    <title>$g_current_organization->longname - Kategorie</title>
    <link rel=\"stylesheet\" type=\"text/css\" href=\"$g_root_path/adm_config/main.css\">

    <!--[if lt IE 7]>
    <script type=\"text/javascript\" src=\"$g_root_path/adm_program/system/correct_png.js\"></script>
    <![endif]-->";

    require("../../../adm_config/header.php");
echo "</head>";

require("../../../adm_config/body_top.php");
    echo "<div style=\"margin-top: 10px; margin-bottom: 10px;\" align=\"center\">
        <h1>Kategorien</h1>

        <p>
            <span class=\"iconLink\">
                <a class=\"iconLink\" href=\"$g_root_path/adm_program/administration/roles/categories_new.php?url=$url\"><img 
                src=\"$g_root_path/adm_program/images/add.png\" style=\"vertical-align: middle;\" border=\"0\" alt=\"Kategorie anlegen\"></a>
                <a class=\"iconLink\" href=\"$g_root_path/adm_program/administration/roles/categories_new.php?url=$url\">Kategorie anlegen</a>
            </span>
        </p>

        <table class=\"tableList\" style=\"width: 300px;\" cellpadding=\"2\" cellspacing=\"0\">
            <tr>
                <th class=\"tableHeader\" style=\"text-align: left;\">Bezeichnung</th>
                <th class=\"tableHeader\"><img style=\"cursor: help;\" src=\"$g_root_path/adm_program/images/lock.png\" alt=\"Kategorie nur f&uuml;r eingeloggte Benutzer sichtbar\" title=\"Kategorie nur f&uuml;r eingeloggte Benutzer sichtbar\"></th>
                <th class=\"tableHeader\">&nbsp;</th>
            </tr>";
            
            $sql = "SELECT * FROM ". TBL_ROLE_CATEGORIES. "
                     WHERE rlc_org_shortname LIKE '$g_organization'
                     ORDER BY rlc_name ASC ";
            $cat_result = mysql_query($sql, $g_adm_con);
            db_error($cat_result);

            while($cat_row = mysql_fetch_object($cat_result))
            {
                // schauen, ob Rollen zu dieser Kategorie existieren
                $sql = "SELECT * FROM ". TBL_ROLES. "
                         WHERE rol_rlc_id = $cat_row->rlc_id ";
                $result = mysql_query($sql, $g_adm_con);
                db_error($result);
                $row_num = mysql_num_rows($result);

                echo "
                <tr class=\"listMouseOut\" onmouseover=\"this.className='listMouseOver'\" onmouseout=\"this.className='listMouseOut'\">
                    <td style=\"text-align: left;\"><a href=\"$g_root_path/adm_program/administration/roles/categories_new.php?rlc_id=$cat_row->rlc_id\">$cat_row->rlc_name</a></td>
                    <td style=\"text-align: center;\">";
                        if($cat_row->rlc_locked == 1)
                        {
                            echo "<img style=\"cursor: help;\" src=\"$g_root_path/adm_program/images/lock.png\" alt=\"Kategorie nur f&uuml;r eingeloggte Benutzer sichtbar\" title=\"Kategorie nur f&uuml;r eingeloggte Benutzer sichtbar\">";
                        }
                        else
                        {
                            echo "&nbsp;";
                        }
                    echo "</td>
                    <td style=\"text-align: right; width: 45px;\">
                        <a href=\"$g_root_path/adm_program/administration/roles/categories_new.php?rlc_id=$cat_row->rlc_id&amp;url=$url\">
                        <img src=\"$g_root_path/adm_program/images/edit.png\" border=\"0\" alt=\"Bearbeiten\" title=\"Bearbeiten\"></a>";
                        // nur Kategorien loeschen, die keine Rollen zugeordnet sind
                        if($row_num == 0)
                        {
                            echo "&nbsp;<a href=\"$g_root_path/adm_program/administration/roles/categories_function.php?rlc_id=$cat_row->rlc_id&amp;mode=3&amp;url=$url\"><img
                            src=\"$g_root_path/adm_program/images/cross.png\" border=\"0\" alt=\"L&ouml;schen\" title=\"L&ouml;schen\"></a>";
                        }
                        else
                        {
                            echo "&nbsp;<img src=\"$g_root_path/adm_program/images/dummy.gif\" width=\"16\" border=\"0\" alt=\"Dummy\">";
                        }
                    echo "</td>
                </tr>";
            }
        echo "</table>

        <p>
            <span class=\"iconLink\">
                <a class=\"iconLink\" href=\"javascript:self.location.href='". urldecode($url). "'\"><img
                class=\"iconLink\" src=\"$g_root_path/adm_program/images/back.png\" style=\"vertical-align: middle;\" border=\"0\" alt=\"Zur&uuml;ck\"></a>
                <a class=\"iconLink\" href=\"javascript:self.location.href='". urldecode($url). "'\">Zur&uuml;ck</a>
            </span>
        </p>
    </div>";

    require("../../../adm_config/body_bottom.php");
echo "</body>
</html>";
?>