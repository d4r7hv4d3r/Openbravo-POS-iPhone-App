/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.openbravo.pos.pda.restresources;

import com.openbravo.pos.pda.bo.RestaurantManager;
import com.openbravo.pos.ticket.CategoryInfo;
import com.openbravo.pos.ticket.Place;
import java.util.List;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;

/**
 *
 * @author axel
 */
@Path("/categories")
public class CategoriesResource {

    RestaurantManager manager = new RestaurantManager();

    @GET
    @Produces("application/json")
    public CategoryInfo[] getCategories() {
        List<CategoryInfo> categories = manager.findAllCategories();
        CategoryInfo[] placesArray = new CategoryInfo[categories.size()];
        categories.toArray(placesArray);
        return placesArray;
    }
}
