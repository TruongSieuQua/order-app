package com.example.orderservice;

import com.baomidou.mybatisplus.generator.FastAutoGenerator;
import com.baomidou.mybatisplus.generator.config.INameConvert;
import com.baomidou.mybatisplus.generator.config.OutputFile;
import com.baomidou.mybatisplus.generator.config.po.TableField;
import com.baomidou.mybatisplus.generator.config.po.TableInfo;
import lombok.NonNull;

import java.util.Collections;

public class MybatisGenerator {

    public static class EntityNameConverter implements INameConvert {
        @Override
        @NonNull
        public String entityNameConvert(@NonNull TableInfo tableInfo) {
            String tableName = tableInfo.getName();
            return switch (tableName) {
                case "addresses" -> "Address";
                case "categories" -> "Category";
                case "order_details" -> "OrderDetail";
                case "orders" -> "Order";
                case "payments" -> "Payment";
                case "products" -> "Product";
                case "products_categories" -> "ProductCategory";
                case "shipment" -> "Shipment";
                case "users" -> "User";
                default -> tableName.substring(0, 1).toUpperCase() + tableName.substring(1);
            };
        }

        @Override
        @NonNull
        public String propertyNameConvert(@NonNull TableField field) {
            String[] parts = field.getName().split("_");
            StringBuilder propertyName = new StringBuilder(parts[0].toLowerCase());
            for (int i = 1; i < parts.length; i++) {
                propertyName.append(parts[i].substring(0, 1).toUpperCase())
                        .append(parts[i].substring(1).toLowerCase());
            }
            return propertyName.toString();
        }
    }

    static final String rootDir = "C://mybatis";

    public static void main(String[] args) {
        FastAutoGenerator.create("jdbc:postgresql://localhost:5432/orderdb", "admin", "admin159@")
                .globalConfig(builder -> {
                    builder.author("truongdeptrai")
                            .enableSwagger()
                            .outputDir("C://mybatis");
                })
                .packageConfig(builder -> {
                    builder.parent("com.example.orderservice")
                            .moduleName("")
                            .entity("model")
                            .mapper("mapper")
                            .pathInfo(Collections.singletonMap(OutputFile.entity, "C://mybatis/src/main/java/com/example/orderservice/model"))
                            .pathInfo(Collections.singletonMap(OutputFile.mapper, "C://mybatis/src/main/java/com/example/orderservice/mapper"))
                            .pathInfo(Collections.singletonMap(OutputFile.xml, "C://mybatis/src/main/resources/mapper"));
                    ;
                })
                .strategyConfig(builder -> {
                    builder.addInclude("orders")
                            .addInclude()
                            .entityBuilder()
                            .enableChainModel()
                            .disableSerialVersionUID()
                            .enableTableFieldAnnotation()
                            .nameConvert(new EntityNameConverter())
                            .mapperBuilder()
                            .enableBaseResultMap()
                            .enableBaseColumnList()
//                            .cache(MyMapperCache.class)
                            .formatMapperFileName("%sMapper")
                            .formatXmlFileName("%sXml")
                            .build();
                })
                .execute();
    }
}
