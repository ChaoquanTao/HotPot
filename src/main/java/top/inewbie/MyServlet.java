package top.inewbie;

import com.google.gson.Gson;
import com.mongodb.MongoClient;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoCursor;
import com.mongodb.client.MongoDatabase;
import org.bson.BsonBoolean;
import org.bson.BsonDocument;
import org.bson.BsonInt32;
import org.bson.Document;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;

public class MyServlet extends HttpServlet {
    public MyServlet() {
        super();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        MongoClient mongoClient = new MongoClient( "localhost" , 27017 );
        MongoDatabase database = mongoClient.getDatabase("busi_run");
        MongoCollection<Document> collection = database.getCollection("out");


        String workday = req.getParameter("isWorkDay");
        String time = req.getParameter("time");
        System.out.println(workday);


        Document[] docs = new Document[2000] ;
        ArrayList list = new ArrayList();
        System.out.println("{\"_id\": {" + "\"isWorkDay\" : " +workday+ ", \"timeID\" : "+time+"}}");
//        collection.find(eq("{\"_id\": {" + "\"isWorkDay\" : " +workday+ ", \"timeID\" : "+time+"}}")).
//        MongoCursor<Document> cursor = collection.find(new BsonDocument().append("_id", new BsonDocument()
//                .append("isWorkDay", new BsonBoolean(true))
//                .append("timeID", new BsonInt32(0)))).iterator();

        MongoCursor<Document> cursor = collection.find(new BsonDocument().append("_id", new BsonDocument()
                .append("isWorkDay", new BsonBoolean(Boolean.parseBoolean(workday)))
                .append("timeID", new BsonInt32(Integer.parseInt(time))))).iterator();

        int cnt = 0;
        try {
            while (cursor.hasNext()) {
                cnt ++ ;
                Document doc = cursor.next();
                //response.getWriter().println(cursor.next().toJson());
                System.out.println(doc.get("value"));
                System.out.println(doc.get("value").getClass());
                if (doc.get("value") instanceof ArrayList) {
                    list.addAll((ArrayList)doc.get("value"));
//                    for (int i = 0; i < list.size(); ++i) {
//                        out.println(list.get(i));
//                        docs[i] = list.get(i) ;
//                    }
                }

            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            cursor.close();
        }
        String  json = new Gson().toJson(list);
        resp.getWriter().write(json);

    }
}
