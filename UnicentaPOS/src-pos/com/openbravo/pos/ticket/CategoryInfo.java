//    uniCenta oPOS  - Touch Friendly Point Of Sale
//    Copyright (c) 2009-2010 uniCenta
//    http://www.unicenta.net/unicentaopos
//
//    This file is part of uniCenta oPOS
//
//    uniCenta oPOS is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation, either version 3 of the License, or
//    (at your option) any later version.
//
//   uniCenta oPOS is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with uniCenta oPOS.  If not, see <http://www.gnu.org/licenses/>.
package com.openbravo.pos.ticket;

import com.openbravo.basic.BasicException;
import com.openbravo.data.loader.DataRead;
import java.awt.image.*;

import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlTransient;

import com.openbravo.data.loader.IKeyed;
import com.openbravo.data.loader.ImageUtils;
import com.openbravo.data.loader.SerializerRead;

/**
 *
 * @author  Adrian
 * @version 
 */
@XmlRootElement
public class CategoryInfo implements IKeyed {

    public static final long serialVersionUID = 8612449444103L;
    private String m_sID;
    private String m_sName;
    
    private BufferedImage m_Image;

    /** Creates new CategoryInfo */
    public CategoryInfo() {
    }
    	
    /** Creates new CategoryInfo */
    public CategoryInfo(String id, String name, BufferedImage image) {
        m_sID = id;
        m_sName = name;
        m_Image = image;
    }

    public Object getKey() {
        return m_sID;
    }

    public void setID(String sID) {
        m_sID = sID;
    }

    public String getID() {
        return m_sID;
    }

    public String getName() {
        return m_sName;
    }

    public void setName(String sName) {
        m_sName = sName;
    }

    @XmlTransient
    public BufferedImage getImage() {
        return m_Image;
    }

    public void setImage(BufferedImage img) {
        m_Image = img;
    }

    @Override
    public String toString() {
        return m_sName;
    }

    public static SerializerRead getSerializerRead() {
        return new SerializerRead() { public Object readValues(DataRead dr) throws BasicException {
            return new CategoryInfo(dr.getString(1), dr.getString(2), ImageUtils.readImage(dr.getBytes(3)));
        }};
    }
}
